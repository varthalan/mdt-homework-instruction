//
//  RegistrationService.swift
//  DigibankLight
//
//  Created by Nagaraju on 30/1/22.
//

import Foundation

final class RegistrationService {
    private let url: URL
    private let client: HTTPClient
    
    typealias Result = Swift.Result<RegistrationResponse, Error>
    
    private struct RegistrationParams: Codable {
        let username: String
        let password: String
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func createAccount(for username: String, password: String, completion: @escaping (Result) -> Void) {
        let params = RegistrationParams(username: username, password: password)
        client.load(request: request(with: params)) { result in
            switch result {
            case let  .success(value):
                do {
                    completion(.success(try  RegistrationServiceMapper.map(value.0, from: value.1)))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func request(with bodyParams: RegistrationParams) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let body = try? JSONEncoder().encode(bodyParams) {
            request.httpBody = body
        }
        
        return request
    }
}
