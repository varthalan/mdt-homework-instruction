//
//  BalanceServiceTests.swift
//  DigibankLightTests
//
//  Created by Nagaraju on 30/1/22.
//

import XCTest
@testable import DigibankLight

struct BalanceResponse: Equatable {
    struct Error: Equatable {
        let name: String
        let message: String
        let tokenExpiryDate: String
    }
    
    let status: String
    let error: Error
}

final class BalanceServiceMapper {
    
    private struct Result: Decodable {
        
        private struct Error: Decodable {
            let name: String
            let message: String
            let expiredAt: String
        }
        
        private let status: String
        private let error: Error
        
        var balanceResponse: BalanceResponse {
            BalanceResponse(
                status: status,
                error: .init(
                    name: error.name,
                    message: error.message,
                    tokenExpiryDate: error.expiredAt
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

class BalanceServiceTests: XCTestCase {
    
    func test_init_doesNotSendRequestToRetrieveAccountBalance() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadBalance_sendsRequestToRetrieveAccountBalance() {
        let url = URL(string: "https://any-url.com/balance")!
        let (sut, client) = makeSUT(url)
        
        sut.loadBalance(jwtToken: "any token") { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadBalance_deliversErrorWithExpiredJWTToken() {
        let url = URL(string: "https://any-url.com/balance")!
        let (sut, client) = makeSUT(url)
        let (failureResponse, json) = makeBalanceResponse(
            status: "failed",
            error: .init(
                name: "any name",
                message: "any messasge",
                tokenExpiryDate: "any date"
            )
        )
        
        let expectedResponse = BalanceService.Result.success(failureResponse)
        let exp = expectation(description: "Wait for loading balance")
        sut.loadBalance(jwtToken: "any expired token") { actualResponse in
            switch (actualResponse, expectedResponse) {
            case let (.success(actualResult), .success(expectedResult)):
                XCTAssertEqual(actualResult, expectedResult)
                
            default:
                XCTFail("Expected \(expectedResponse), got \(actualResponse)")
            }
            
            exp.fulfill()
        }
        client.complete(with: makeJSON(with: json))
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(_ url: URL = URL(string: "https://any-url.com")!) -> (sut: BalanceService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = BalanceService(url: url, client: client)
        return (sut, client)
    }
    
    private func makeBalanceResponse(
        status: String,
        error: BalanceResponse.Error
    ) -> (response: BalanceResponse, json: [String: Any]) {
        let response = BalanceResponse(
            status: status,
            error: .init(
                name: error.name,
                message: error.message,
                tokenExpiryDate: error.tokenExpiryDate
            )
        )
        
        let json: [String: Any] = [
            "status": status,
            "error": [
                "name": error.name,
                "message": error.message,
                "expiredAt": error.tokenExpiryDate
            ]
        ]
        
        return (response, json)
    }
}
