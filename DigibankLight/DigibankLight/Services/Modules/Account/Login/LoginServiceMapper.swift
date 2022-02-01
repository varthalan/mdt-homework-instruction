//
//  LoginServiceMapper.swift
//  DigibankLight
//

import Foundation

final class LoginServiceMapper {
    
    private struct Result: Decodable {
        let status: String
        let token: String?
        let username: String?
        let accountNo: String?
        let error: String?
        
        var response: LoginResponse {
            LoginResponse(
                status: status,
                jwtToken: token,
                username: username,
                accountNumber: accountNo,
                error: error)
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> LoginResponse {
        guard let result = try? Mapper<Result>.map(data, from: response) else {
            throw NSError(domain: "Parsing error in LoginService response", code: 0)
        }

        return result.response
    }
}
