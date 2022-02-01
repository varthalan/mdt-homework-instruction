//
//  BalanceServiceMapper.swift
//  DigibankLight
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
        private let balance: Double?
        private let error: Error?
        
        var response: BalanceResponse {
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
        guard let result = try? Mapper<Result>.map(data, from: response) else {
            throw NSError(domain: "Parsing error in Balance response", code: 0)
        }
        
        return result.response
    }
}
