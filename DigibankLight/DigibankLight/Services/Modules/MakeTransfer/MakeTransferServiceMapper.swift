//
//  MakeTransferServiceMapper.swift
//  DigibankLight
//
//  Created by Nagaraju on 30/1/22.
//

import Foundation

final class MakeTransferServiceMapper {
    
    private struct Result: Decodable {
        
        private struct Error: Decodable {
            let name: String?
            let message: String?
            let expiredAt: String?
        }
        
        private let status: String
        private let transactionId: String?
        private let amount: Int?
        private let description: String?
        private let recipientAccount: String?
        private let error: Error?
        
        var transferResponse: MakeTransferResponse {
            MakeTransferResponse(
                status: status,
                transactionId: transactionId,
                amount: amount,
                description: description,
                accountNumber: recipientAccount,
                error: .init(
                    name: error?.name,
                    message: error?.message,
                    tokenExpiredDate: error?.expiredAt
                )
            )
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> MakeTransferResponse {
        guard let response = try? JSONDecoder().decode(Result.self, from: data) else {
            throw NSError(domain: "Parsing error makeTransfer response", code: 0)
        }
        
        return response.transferResponse
    }
}
