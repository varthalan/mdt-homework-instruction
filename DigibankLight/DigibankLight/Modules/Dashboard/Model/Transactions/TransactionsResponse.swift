//
//  TransactionsResponse.swift
//  DigibankLight
//

import Foundation

struct TransactionsResponse: Equatable {
    
    struct Transaction: Equatable {
        let transactionId: String?
        let amount: Double?
        let transactionDate: Date?
        let description: String?
        let transactionType: String?
        let accountNumber: String?
        let accountName: String?
    }
    
    struct Error: Equatable {
        let name: String?
        let message: String?
        let tokenExpiredDate: String?
    }
    
    let status: String
    let transactions: [Transaction]?
    let error: Error?
}
