//
//  MakeTransferResponse.swift
//  DigibankLight
//

import Foundation

struct MakeTransferResponse: Equatable {
    
    struct Error: Equatable {
        let name: String?
        let message: String?
        let tokenExpiredDate: String?
    }
    
    let status: String
    let transactionId: String?
    let amount: Double?
    let description: String?
    let accountNumber: String?
    let errorMessage: String?
    let error: Error?
}
