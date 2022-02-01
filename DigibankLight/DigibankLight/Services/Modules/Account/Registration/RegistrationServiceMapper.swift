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
        guard let result = try? Mapper<Result>.map(data, from: response) else {
            throw NSError(domain: "Parsing error in Registration response", code: 0)
        }

        return result.response
    }
}
