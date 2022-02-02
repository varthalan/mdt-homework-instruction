//
//  DashboardViewModel.swift
//  DigibankLight
//

import Foundation

final class DashboardViewModel {
    private let balanceService: BalanceService
    private let transactionsService: TransactionsService
    private let accountHolderName: String
    private let jwtToken: String
    
    private var transactionsResponse: TransactionsResponse?
    private var balanceResponse: BalanceResponse?
    private var anyError: Error?
    
    typealias Observer<T> = (T) -> Void
    
    var onLoadingStateChange: Observer<Bool>?
    var onDashboardLoad: (()-> Void)?
    var onError: ((String, Bool) -> Void)?
    
    typealias Balance = (accountBalance: String, accountNumber: String, accountHolder: String)
    
    var balance: Balance? {
        guard let balanceResponse = balanceResponse,
              let balance = balanceResponse.balance,
              let accountBalance = convertAmount(Double(balance), prefixCurrency: true),
              let accountNumber = balanceResponse.accountNumber else {
            return nil
        }

        return (accountBalance, accountNumber, accountHolderName)
    }
    
    var transactions: [[Int: [String: Any]]] {
        guard let allTransactions = self.transactionsResponse?.transactions,
              let transactions = self.sortedTransactions(allTransactions) else {
                  return [[Int: [String: Any]]]()
              }
        return transactions
    }


    init(balanceService: BalanceService,
         transactionsService: TransactionsService,
         accountHolderName: String,
         jwtToken: String) {
        self.balanceService = balanceService
        self.transactionsService = transactionsService
        self.accountHolderName = accountHolderName
        self.jwtToken = jwtToken
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

    func convertAmount(_ amount: Double?, prefixCurrency: Bool = false) -> String? {
        guard let value = amount else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = prefixCurrency ? "SGD" : ""
        formatter.maximumFractionDigits = 2
        let number = NSNumber(value: value)
        guard let formattedNumber = formatter.string(from: number) else { return nil }
        return formattedNumber
    }

    func loadDashboard() {
        onLoadingStateChange?(true)
        let dispatchGroup = DispatchGroup()
        loadBalance(in: dispatchGroup)
        loadTransactions(in: dispatchGroup)
        notifyDispatchGroup(dispatchGroup)
    }
    
    private func loadBalance(in dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        
        balanceService.loadBalance(jwtToken: jwtToken) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(response):
                if let errorMessage = response.error?.message,
                   let errorName = response.error?.name {
                    self.onError?(errorMessage, Utitlies.isSessionExpiredMessage(errorName))
                } else {
                    self.balanceResponse = response
                }
                
            case let .failure(error):
                self.anyError = error
            }
            
            dispatchGroup.leave()
        }
    }
    
    private func loadTransactions(in dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        
        transactionsService.load(token: jwtToken) { [weak self] result in
            guard let self = self else { return }
            
            self.onLoadingStateChange?(false)
            switch result {
            case let .success(response):
                if let errorMessage = response.error?.message,
                          let errorName = response.error?.name {
                    self.onError?(errorMessage, Utitlies.isSessionExpiredMessage(errorName))
                } else {
                    self.transactionsResponse = response
                }
                
            case let  .failure(error):
                self.anyError = error
            }
            
            dispatchGroup.leave()
        }
    }
    
    private func notifyDispatchGroup(_ dispatchGroup: DispatchGroup) {
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            self.onLoadingStateChange?(false)
            
            if let error = self.anyError {
                self.onError?(error.localizedDescription, false)
            } else {
                self.onDashboardLoad?()
            }
        }
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
    
    static var yourTransactionHistory: String {
        localize("your_transaction_history")
    }
}
