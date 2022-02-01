//
//  PayeerService.swift
//  DigibankLight
//

import Foundation

final class PayeesServiceMapper {
    
    private struct Result: Decodable {
        
        private struct Error: Decodable {
            let name: String?
            let message: String?
            let expiredAt: String?
        }
        
        private struct AccountPayee: Decodable {
            let id: String?
            let name: String?
            let accountNo: String?
        }
        
        private let status: String
        private let data: [AccountPayee]?
        private let error: Error?

        var response: PayeesResponse {
            
            let payees = data?.map {
                PayeesResponse.Payee(id: $0.id,
                      name: $0.name,
                      accountNumber: $0.accountNo
                )
            }
            
            return PayeesResponse(
                status: status,
                payees: payees,
                error: .init(
                    name: error?.name,
                    message: error?.message,
                    tokenExpiredDate: error?.expiredAt)
            )
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> PayeesResponse {
        guard let result = try? Mapper<Result>.map(data, from: response) else {
            throw NSError(domain: "Parsing error from PayeesService", code: 0)
        }
        
        return result.response
    }
}
