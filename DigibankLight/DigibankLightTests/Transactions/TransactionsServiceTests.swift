//
//  TransactionsServiceTests.swift
//  DigibankLightTests
//

import XCTest
@testable import DigibankLight

struct TransactionsResponse: Equatable {
    
    struct Error: Equatable {
        let name: String
        let message: String
        let tokenExpiredDate: String
    }
    
    let status: String
    let error: Error
}

final class TransactionsServiceMapper {
    
    private struct Result: Decodable {
        
        private struct Error: Decodable {
            let name: String
            let message: String
            let expiredAt: String
        }
        
        private let status: String
        private let error: Error
        
        var transactionsResponse: TransactionsResponse {
            TransactionsResponse(
                status: status,
                error: .init(
                    name: error.name,
                    message: error.message,
                    tokenExpiredDate: error.expiredAt)
            )
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> TransactionsResponse {
        guard let response = try? JSONDecoder().decode(Result.self, from: data) else {
            throw NSError(domain: "Parsing error from TransactionsService", code: 0)
        }
        
        return response.transactionsResponse
    }
}

final class TransactionsService {
    private let url: URL
    private let client: HTTPClient
    
    typealias Result = Swift.Result<TransactionsResponse, Error>
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(token: String, completion: @escaping (Result) -> Void) {
        client.load(request: request()) { result in
            switch result {
            case let .success(value):
                do {
                    completion(.success(try TransactionsServiceMapper.map(value.0, from: value.1)))
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

class TransactionsServiceTests: XCTestCase {

    func test_init_doesNotSendRequestToLoadTransactions() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_sendsRequestToLoadTransactions() {
        let url = URL(string: "https://any-url.com/transactions")!
        let (sut, client) = makeSUT(url)
        
        sut.load(token: "any token") { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_deliversErrorWithExpiredToken() {
        let url = URL(string: "https://any-url.com/transactions")!
        let (sut, client) = makeSUT(url)
        let (failedResponse, json) = makeTransactionsResponse(
            status: "failed",
            error: .init(
                name: "any name",
                message: "any message",
                tokenExpiredDate: "any date"
            )
        )
        let expectedResult = TransactionsService.Result.success(failedResponse)
        
        let exp = expectation(description: "Wait for loading transactions")
        sut.load(token: "any token") { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedResponse), .success(expectedResponse)):
                XCTAssertEqual(receivedResponse, expectedResponse)
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult)")
            }
            
            exp.fulfill()
        }
        client.complete(with: makeJSON(with: json))
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(_ url: URL = URL(string: "https://any-url.com")!) -> (sut: TransactionsService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = TransactionsService(url: url, client: client)
        return (sut, client)
    }
    
    private func makeTransactionsResponse(
        status: String,
        error: TransactionsResponse.Error
    ) -> (response: TransactionsResponse, json: [String: Any]) {
        let response = TransactionsResponse(
            status: status,
            error: error
        )
        
        let json: [String: Any] = [
            "status": status,
            "error": [
                "name": error.name,
                "message": error.message,
                "expiredAt": error.tokenExpiredDate
            ]
        ]
        
        return (response, json)
    }
}
