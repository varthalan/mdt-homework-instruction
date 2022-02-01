//
//  TransactionsServiceMapper.swift
//  DigibankLight
//
//  Created by Nagaraju on 30/1/22.
//

import Foundation

final class TransactionsServiceMapper {
    
    private struct Result: Decodable {
        
        private struct Transaction: Decodable {
            
            struct Receipient: Decodable {
                let accountNo: String?
                let accountHolder: String?
            }
            
            struct Sender: Decodable {
                let accountNo: String?
                let accountHolder: String?
            }
            
            let transactionId: String?
            let amount: Int?
            let transactionDate: String?
            let description: String?
            let transactionType: String?
            let receipient: Receipient?
            let sender: Sender?
        }
        
        private struct Error: Decodable {
            let name: String?
            let message: String?
            let expiredAt: String?
        }
        
        private let status: String
        private let data: [Transaction]?
        private let error: Error?
        
        var transactionsResponse: TransactionsResponse {
            let transactions = data?.map({ transaction -> TransactionsResponse.Transaction in
                let transactionType = transaction.transactionType
                var accountNumber: String?
                var accountName: String?
                if transactionType != nil && transactionType! == "transfer" {
                    accountNumber = transaction.receipient?.accountNo
                    accountName = transaction.receipient?.accountHolder
                } else {
                    accountNumber = transaction.sender?.accountNo
                    accountName = transaction.sender?.accountHolder
                }

                return TransactionsResponse.Transaction(
                    transactionId: transaction.transactionId,
                    amount: transaction.amount,
                    transactionDate: transaction.transactionDate?.shortDate(),
                    description: transaction.description,
                    transactionType: transaction.transactionType,
                    accountNumber: accountNumber,
                    accountName: accountName
                )
            })
            return TransactionsResponse(
                status: status,
                transactions: transactions,
                error: .init(name: error?.name, message: error?.message, tokenExpiredDate: error?.expiredAt))
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> TransactionsResponse {
        guard let response = try? JSONDecoder().decode(Result.self, from: data) else {
            throw NSError(domain: "Parsing error from TransactionsService", code: 0)
        }
        
        return response.transactionsResponse
    }
}
