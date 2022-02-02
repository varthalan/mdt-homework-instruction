//
//  BalanceService.swift
//  DigibankLight
//

import Foundation

final class BalanceService {
    private let url: URL
    private let client: HTTPClient
    
    typealias Result = Swift.Result<BalanceResponse, Error>
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func loadBalance(jwtToken: String, completion: @escaping (Result) -> Void) {
        client.load(request: request(with: jwtToken)) { result in
            switch result {
            case let .success(value):
                do {
                    completion(.success(try BalanceServiceMapper.map(value.0, from: value.1)))
                } catch {
                    completion(.failure(error))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func request(with jwtToken: String) -> URLRequest {
        URLRequest.makeRequest(with: url, method: .get, jwtToken: jwtToken)
    }
}
