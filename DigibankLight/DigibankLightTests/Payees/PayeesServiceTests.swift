//
//  PayeesServiceTests.swift
//  DigibankLightTests
//
//  Created by Nagaraju on 30/1/22.
//

import XCTest
@testable import DigibankLight

struct PayeesResponse: Equatable {

    struct Payee: Equatable {
        let id: String?
        let name: String?
        let accountNumber: String?
    }

    struct Error: Equatable {
        let name: String?
        let message: String?
        let tokenExpiredDate: String?
    }
    
    let status: String
    let payees: [Payee]?
    let error: Error?
}

final class PayeesServiceMapper {
    
    private struct Result: Decodable {
        
        private struct Error: Decodable {
            let name: String?
            let message: String?
            let expiredAt: String?
        }
        
        private struct AccountPayee: Decodable {
            let id: String?
            let name: String?
            let accountNo: String?
        }
        
        private let status: String
        private let data: [AccountPayee]?
        private let error: Error?

        var payeesResponse: PayeesResponse {
            
            let payees = data?.map {
                PayeesResponse.Payee(id: $0.id,
                      name: $0.name,
                      accountNumber: $0.accountNo
                )
            }
            
            return PayeesResponse(
                status: status,
                payees: payees,
                error: .init(
                    name: error?.name,
                    message: error?.message,
                    tokenExpiredDate: error?.expiredAt)
            )
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> PayeesResponse {
        guard let response = try? JSONDecoder().decode(Result.self, from: data) else {
            throw NSError(domain: "Parsing error from PayeesService", code: 0)
        }
        
        return response.payeesResponse
    }
}

final class PayeesService {
    private let url: URL
    private let client: HTTPClient
    
    typealias Result = Swift.Result<PayeesResponse, Error>
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(jwtToken: String, completion: @escaping (Result) -> Void) {
        client.load(request: request()) { result in
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
    
    private func request() -> URLRequest {
        URLRequest(url: url)
    }
}

class PayeesServiceTests: XCTestCase {
    
    func test_init_doesNotSendRequestToLoadPayees() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_sendsRequestToLoadPayees() {
        let url = URL(string: "https:any-url.com/payees")!
        let (sut, client) = makeSUT(url)
        
        sut.load(jwtToken: "any token") { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_deliversErrorWithExpiredToken() {
        let url = URL(string: "https:any-url.com/payees")!
        let (sut, client) = makeSUT(url)
        let (failedResponse, json) = makePayeesResponse(
            status: "failed",
            error: .init(
                name: "any name",
                message: "any message",
                tokenExpiredDate: "any date"
            )
        )
        let expectedResult = PayeesService.Result.success(failedResponse)
        
        let exp = expectation(description: "Wait for loading payees")
        sut.load(jwtToken: "any token") { receivedResult in
            
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
    
    func test_load_completesLoadingPayeesSuccesfully() {
        let url = URL(string: "https:any-url.com/payees")!
        let (sut, client) = makeSUT(url)
        let (successResponse, json) = makePayeesResponse(
            status: "failed",
            error: .init(
                name: "any name",
                message: "any message",
                tokenExpiredDate: "any date"
            )
        )
        let expectedResult = PayeesService.Result.success(successResponse)
        
        let exp = expectation(description: "Wait for loading payees")
        sut.load(jwtToken: "any token") { receivedResult in
            
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
    
    private func makeSUT(_ url: URL = URL(string: "https://any-url.com")!) -> (sut: PayeesService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = PayeesService(url: url, client: client)
        return (sut, client)
    }

    private func makePayeesResponse(
        status: String,
        payees: [PayeesResponse.Payee]? = nil,
        error: PayeesResponse.Error? = nil
    ) -> (response: PayeesResponse, json: [String: Any]) {
        let response = PayeesResponse(
            status: status,
            payees: payees,
            error: error
        )
        
        let jsonPayees = payees?.map { [
            "id": $0.id,
            "name": $0.name,
            "accountNo": $0.accountNumber
        ]}
        
        let json: [String: Any] = [
            "status": status,
            "data": jsonPayees,
            "error": [
                "name": error?.name,
                "message": error?.message,
                "expiredAt": error?.tokenExpiredDate
            ]
        ].compactMapValues { $0 }
        
        return (response, json)
    }
}
