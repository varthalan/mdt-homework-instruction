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

final class BalanceServiceMapper {
    
    private struct Result: Decodable {
        
        private struct Error: Decodable {
            let name: String?
            let message: String?
            let expiredAt: String?
        }
        
        private let status: String
        private let accountNo: String?
        private let balance: Int?
        private let error: Error?
        
        var balanceResponse: BalanceResponse {
            BalanceResponse(
                status: status,
                accountNumber: accountNo,
                balance: balance,
                error: .init(
                    name: error?.name,
                    message: error?.message,
                    tokenExpiryDate: error?.expiredAt
                )
            )
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> BalanceResponse {
        
        guard let response = try? JSONDecoder().decode(Result.self, from: data) else {
            throw NSError(domain: "Parsing error in Registration response", code: 0)
        }
        
        return response.balanceResponse
    }
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
