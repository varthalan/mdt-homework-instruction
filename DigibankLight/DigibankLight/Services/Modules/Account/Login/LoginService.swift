//
//  LoginService.swift
//  DigibankLight
//
//  Created by Nagaraju on 29/1/22.
//

import Foundation

final class LoginService {    
    private let url: URL
    private let client: HTTPClient
    
    typealias Result = Swift.Result<LoginResponse, Error>

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func login(username: String, password: String, completion: @escaping (Result) -> Void) {
        client.load(request: request()) { result in
            switch result {
            case let .success(value):
                let (data, response) = value
                do {
                    completion(.success(try LoginServiceMapper.map(data, from: response)))
                } catch {
                    completion(.failure(error))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func request() -> URLRequest {
        URLRequest(url: url)
    }
}
