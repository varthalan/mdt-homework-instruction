//
//  LoginServiceMapper.swift
//  DigibankLight
//
//  Created by Nagaraju on 29/1/22.
//

import Foundation

final class LoginServiceMapper {
    
    private struct Response: Decodable {
        let status: String
        let token: String?
        let username: String?
        let accountNo: String?
        let error: String?
        
        var loginResponse: LoginResponse {
            LoginResponse(
                status: status,
                jwtToken: token,
                username: username,
                accountNumber: accountNo,
                error: error)
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> LoginResponse {
        guard let response = try? JSONDecoder().decode(Response.self, from: data) else {
            throw NSError(domain: "Parsing error in LoginService", code: 0)
        }
        
        return response.loginResponse
    }
}
