//
//  DigibankEndPoints.swift
//  DigibankLight
//

import Foundation

enum DigibankEndPoints {
    case login
    case register
    case balance
    case transactions
    case transfer
    case payees

    func url(baseURL: URL) -> URL {
        switch self {
        case .login:
            return baseURL.appendingPathComponent("/login")
            
        case .register:
            return baseURL.appendingPathComponent("/register")
            
        case .balance:
            return baseURL.appendingPathComponent("/balance")
            
        case .transactions:
            return baseURL.appendingPathComponent("/transactions")
            
        case .transfer:
            return baseURL.appendingPathComponent("/transfer")
            
        case .payees:
            return baseURL.appendingPathComponent("/payees")
        }
    }
}
