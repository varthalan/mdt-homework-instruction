//
//  BalanceService.swift
//  DigibankLight
//
//  Created by Nagaraju on 30/1/22.
//

import Foundation

struct BalanceResponse: Equatable {
    struct Error: Equatable {
        let name: String?
        let message: String?
        let tokenExpiryDate: String?
    }
    
    let status: String
    let accountNumber: String?
    let balance: Int?
    let error: Error?
}

final class BalanceService {
    private let url: URL
    private let client: HTTPClient
    
    typealias Result = Swift.Result<BalanceResponse, Error>
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func loadBalance(jwtToken: String, completion: @escaping (Result) -> Void) {
        client.load(request: request()) { result in
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
    
    private func request() -> URLRequest {
        URLRequest(url: url)
    }
}
