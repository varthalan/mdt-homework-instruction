//
//  MakeTransferResponse.swift
//  DigibankLight
//
//  Created by Nagaraju on 30/1/22.
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
    let amount: Int?
    let description: String?
    let accountNumber: String?
    let error: Error?
}
