//
//  BalanceResponse.swift
//  DigibankLight
//
//  Created by Nagaraju on 30/1/22.
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
    let balance: Int?
    let error: Error?
}
