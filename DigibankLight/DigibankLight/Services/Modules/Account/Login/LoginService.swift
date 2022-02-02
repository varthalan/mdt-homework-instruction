//
//  LoginService.swift
//  DigibankLight
//

import Foundation

final class LoginService {    
    private let url: URL
    private let client: HTTPClient
    
    private struct LoginParams: Codable {
        let username: String
        let password: String
    }

    typealias Result = Swift.Result<LoginResponse, Error>

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func login(username: String, password: String, completion: @escaping (Result) -> Void) {
        let params = LoginParams(username: username, password: password)
        client.load(request: request(with: params)) { result in
            switch result {
            case let .success(value):
                do {
                    completion(.success(try LoginServiceMapper.map(value.0, from: value.1)))
                } catch {
                    completion(.failure(error))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func request(with bodyParams: LoginParams) -> URLRequest {
        var request = URLRequest.makeRequest(
            with: url,
            method: .post
        )
        if let body = try? JSONEncoder().encode(bodyParams) {
            request.httpBody = body
        }

        return request
    }
    
}
