//
//  MakeTransferService.swift
//  DigibankLight
//

import Foundation

final class MakeTransferService {
    private let url: URL
    private let client: HTTPClient
    
    typealias Result = Swift.Result<MakeTransferResponse, Error>
    
    private struct MakeTransferParams: Codable {
        let receipientAccountNo: String
        let amount: Double
        let description: String?
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func transfer(
        accountNumber: String,
        amount: Double,
        description: String? = nil,
        jwtToken: String,
        completion: @escaping (Result) -> Void) {
            let params = createTransferParams(
                accountNumber: accountNumber,
                amount: amount,
                description: description)
            client.load(request: request(with: params, jwtToken: jwtToken)) { result in
                switch result {
                case let .success(value):
                    do {
                        completion(.success(try MakeTransferServiceMapper.map(value.0, from: value.1)))
                    } catch {
                        completion(.failure(error))
                    }
                    
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    
    
    private func createTransferParams(
        accountNumber: String,
        amount: Double,
        description: String? = nil) -> MakeTransferParams {
            MakeTransferParams(
                receipientAccountNo: accountNumber,
                amount: amount,
                description: description
            )
        }
    
    private func request(with params: MakeTransferParams, jwtToken: String) -> URLRequest {
        var request = URLRequest.makeRequest(
            with: url,
            method: .post,
            jwtToken: jwtToken
        )        
        if let body = try? JSONEncoder().encode(params) {
            request.httpBody = body
        }
        
        return request
    }
}
