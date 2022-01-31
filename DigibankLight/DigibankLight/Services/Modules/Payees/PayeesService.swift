//
//  PayeesService.swift
//  DigibankLight
//
//  Created by Nagaraju on 30/1/22.
//

import Foundation

final class PayeesService {
    private let url: URL
    private let client: HTTPClient
    
    typealias Result = Swift.Result<PayeesResponse, Error>
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(jwtToken: String, completion: @escaping (Result) -> Void) {
        client.load(request: request(with: jwtToken)) { result in
            switch result {
            case let .success(value):
                do {
                    completion(.success(try PayeesServiceMapper.map(value.0, from: value.1)))
                } catch {
                    completion(.failure(error))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func request(with jwtToken: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(jwtToken, forHTTPHeaderField: "Authorization")
                
        return request
    }
}
