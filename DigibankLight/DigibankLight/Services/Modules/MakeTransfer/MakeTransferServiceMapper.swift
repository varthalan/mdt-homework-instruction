//
//  MakeTransferServiceMapper.swift
//  DigibankLight
//

import Foundation

final class MakeTransferServiceMapper {
    
    struct Result: Decodable {
        
        private struct Error: Decodable {
            enum ErrorCodingKeys: String, CodingKey {
                case name, message, expiredAt
            }

            let name: String?
            let message: String?
            let expiredAt: String?
        }
                
        enum CodingKeys: String, CodingKey {
            case status, transactionId, amount, description, recipientAccount
            case errorKey = "error"
        }
        
        private let status: String
        private let transactionId: String?
        private let amount: Double?
        private let description: String?
        private let recipientAccount: String?
        private var otherError: Error?
        private var errorString: String?
                
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            status = try container.decode(String.self, forKey: .status)
            transactionId = try container.decodeIfPresent(String.self, forKey: .transactionId)
            amount = try container.decodeIfPresent(Double.self, forKey: .amount)
            description = try container.decodeIfPresent(String.self, forKey: .description)
            recipientAccount = try container.decodeIfPresent(String.self, forKey: .recipientAccount)
            errorString = nil
            otherError = nil
            do {
                errorString = try container.decode(String.self, forKey: .errorKey)
                
            } catch {
                otherError = try container.decodeIfPresent(Error.self, forKey: .errorKey)
            }
        }
                
        var response: MakeTransferResponse {
            MakeTransferResponse(
                status: status,
                transactionId: transactionId,
                amount: amount,
                description: description,
                accountNumber: recipientAccount,
                errorMessage: errorString,
                error: .init(
                    name: otherError?.name,
                    message: otherError?.message,
                    tokenExpiredDate: otherError?.expiredAt
                )
            )
        }
    }
        
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> MakeTransferResponse {
        guard let result = try? Mapper<Result>.map(data, from: response) else {
            throw NSError(domain: "Parsing error makeTransfer response", code: 0)
        }

        return result.response
    }
}
