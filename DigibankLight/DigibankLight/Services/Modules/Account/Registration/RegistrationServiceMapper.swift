//
//  RegistrationServiceMapper.swift
//  DigibankLight
//

import Foundation

final class RegistrationServiceMapper {
    
    private struct Result: Decodable {
        let status: String
        let token: String?
        let error: String?
        
        var response: RegistrationResponse {
            RegistrationResponse(
                status: status,
                jwtToken: token,
                error: error
            )
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> RegistrationResponse {
        guard let registrationResponse = try? JSONDecoder().decode(Result.self, from: data) else {
            throw NSError(domain: "Parsing error in Registration response", code: 0)
        }
        return registrationResponse.response
    }
}
