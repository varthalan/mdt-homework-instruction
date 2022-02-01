//
//  PayeesResponse.swift
//  DigibankLight
//

import Foundation

struct PayeesResponse: Equatable {

    struct Payee: Equatable {
        let id: String?
        let name: String?
        let accountNumber: String?
    }

    struct Error: Equatable {
        let name: String?
        let message: String?
        let tokenExpiredDate: String?
    }
    
    let status: String
    let payees: [Payee]?
    let error: Error?
}
