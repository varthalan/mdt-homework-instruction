//
//  DashboardViewModel.swift
//  DigibankLight
//

import Foundation

final class DashboardViewModel {
    private let balanceService: BalanceService
    private let transactionsService: TransactionsService
    private let jwtToken: String
    
    private var transactionsResponse: TransactionsResponse?
    private var anyError: Error?
    
    var onLoadingStateChange: ((Bool) -> Void)?
    var onDashboardLoad: (()-> Void)?
    var onError: ((String) -> Void)?
    
    var transactions: [[Int: [String: Any]]] {
        guard let allTransactions = self.transactionsResponse?.transactions,
              let transactions = self.sortedTransactions(allTransactions) else {
                  return [[Int: [String: Any]]]()
              }
        return transactions
    }


    init(balanceService: BalanceService,
         transactionsService: TransactionsService,
         jwtToken: String) {
        self.balanceService = balanceService
        self.transactionsService = transactionsService
        self.jwtToken = jwtToken
    }

    func loadDashboard() {
        onLoadingStateChange?(true)
        loadTransactions()
    }
    
    private func loadTransactions() {
        transactionsService.load(token: jwtToken) { [weak self] result in
            guard let self = self else { return }
            
            self.onLoadingStateChange?(false)
            switch result {
            case let .success(response):
                if let error = response.error,
                   let message = error.message {
                    self.onError?(message)
                } else {
                    self.transactionsResponse = response
                    self.onDashboardLoad?()
                }
                
            case let  .failure(error):
                self.onError?(error.localizedDescription)
                
            }
        }
    }
    
    func groupTransactions(at section: Int) -> (String, [TransactionsResponse.Transaction]) {
        guard let sectionTransactions = transactions[section] as? [Int: [String: Any]],
              let transactionGroup = sectionTransactions[section],
              let groupName = transactionGroup["Date"] as? String,
              let transactions = transactionGroup["Transactions"] as? [TransactionsResponse.Transaction] else {
                return ("", [TransactionsResponse.Transaction]())
        }
        return (groupName, transactions)
    }

    func convertAmount(_ amount: Int?, prefixCurrency: Bool = false) -> String? {
        guard let value = amount else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = prefixCurrency ? "SGD" : ""
        formatter.maximumFractionDigits = 2        
        let number = NSNumber(value: value)
        guard let formattedNumber = formatter.string(from: number) else { return nil }
        return formattedNumber
    }
    
    private func sortedTransactions(_ transactions: [TransactionsResponse.Transaction]) -> [[Int: [String: Any]]]? {
        let groupedOptTransactions = Dictionary(grouping: transactions) { $0.transactionDate }
        
        guard let groupedTransactions = groupedOptTransactions as? [Date: [TransactionsResponse.Transaction]] else {
            return nil
        }
        
        let orderedGroupedTransactions = groupedTransactions.sorted {  $0.0 > $1.0 }
        var section = 0
        let finalTransactions = orderedGroupedTransactions.map { (key: Date, value: [TransactionsResponse.Transaction]) -> [Int: [String: Any]] in
            let transactionsGroup = [
                section: [
                    "Date": key.toString(),
                    "Transactions": value
                ]
            ]
            section += 1
            
            return transactionsGroup
        }
        
        return finalTransactions
    }
}

//MARK: - Strings
extension DashboardViewModel {
    
    static var logoutButtonTitle: String {
        localize("logout_button_title")
    }

    static var makeTransferButtonTitle: String {
        localize("make_transfer_button_title")
    }
}

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: self)
    }
}
