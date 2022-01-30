//
//  BalanceServiceMapper.swift
//  DigibankLight
//
//  Created by Nagaraju on 30/1/22.
//

import Foundation

final class BalanceServiceMapper {
    
    private struct Result: Decodable {
        
        private struct Error: Decodable {
            let name: String?
            let message: String?
            let expiredAt: String?
        }
        
        private let status: String
        private let accountNo: String?
        private let balance: Int?
        private let error: Error?
        
        var balanceResponse: BalanceResponse {
            BalanceResponse(
                status: status,
                accountNumber: accountNo,
                balance: balance,
                error: .init(
                    name: error?.name,
                    message: error?.message,
                    tokenExpiryDate: error?.expiredAt
                )
            )
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> BalanceResponse {
        
        guard let response = try? JSONDecoder().decode(Result.self, from: data) else {
            throw NSError(domain: "Parsing error in Registration response", code: 0)
        }
        
        return response.balanceResponse
    }
}
