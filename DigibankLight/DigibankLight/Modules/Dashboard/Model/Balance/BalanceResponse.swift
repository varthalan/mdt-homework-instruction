//
//  BalanceResponse.swift
//  DigibankLight
//

import Foundation

struct BalanceResponse: Equatable {
    struct Error: Equatable {
        let name: String?
        let message: String?
        let tokenExpiryDate: String?
    }
    
    let status: String
    let accountNumber: String?
    let balance: Double?
    let error: Error?
}
