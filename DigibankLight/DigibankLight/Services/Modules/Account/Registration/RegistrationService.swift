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
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func createAccount(for username: String, password: String, completion: @escaping (Result) -> Void) {
        client.load(request: request()) { result in
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
    
    private func request() -> URLRequest {
        URLRequest(url: url)
    }
}
