//
//  TransactionsResponse.swift
//  DigibankLight
//
//  Created by Nagaraju on 30/1/22.
//

import Foundation

struct TransactionsResponse: Equatable {
    
    struct Transaction: Equatable {
        let transactionId: String?
        let amount: Int?
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
