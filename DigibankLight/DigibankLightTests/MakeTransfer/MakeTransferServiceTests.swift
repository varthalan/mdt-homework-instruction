//
//  MakeTransferServiceTests.swift
//  DigibankLightTests
//

import XCTest

struct MakeTransferResponse: Equatable {
    
    struct Error: Equatable {
        let name: String?
        let message: String?
        let tokenExpiredDate: String?
    }
    
    let status: String
    let transactionId: String?
    let amount: Int?
    let description: String?
    let accountNumber: String?
    let error: Error?
}

final class MakeTransferServiceMapper {
    
    private struct Result: Decodable {
        
        private struct Error: Decodable {
            let name: String?
            let message: String?
            let expiredAt: String?
        }
        
        private let status: String
        private let transactionId: String?
        private let amount: Int?
        private let description: String?
        private let recipientAccount: String?
        private let error: Error?
        
        var transferResponse: MakeTransferResponse {
            MakeTransferResponse(
                status: status,
                transactionId: transactionId,
                amount: amount,
                description: description,
                accountNumber: recipientAccount,
                error: .init(
                    name: error?.name,
                    message: error?.message,
                    tokenExpiredDate: error?.expiredAt
                )
            )
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> MakeTransferResponse {
        guard let response = try? JSONDecoder().decode(Result.self, from: data) else {
            throw NSError(domain: "Parsing error makeTransfer response", code: 0)
        }
        
        return response.transferResponse
    }
}

final class MakeTransferService {
    private let url: URL
    private let client: HTTPClientSpy
    
    typealias Result = Swift.Result<MakeTransferResponse, Error>
    
    init(url: URL, client: HTTPClientSpy) {
        self.url = url
        self.client = client
    }
    
    func transfer(jwtToken: String, completion: @escaping (Result) -> Void) {
        client.load(request: request()) { result in
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
    
    private func request() -> URLRequest {
        URLRequest(url: url)
    }
}

class MakeTransferServiceTests: XCTestCase {
    
    func test_init_doesNotInitiateTransfer() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_transfer_sendsRequestToTransfer() {
        let url = URL(string: "https://any-url.com/transfer")!
        let (sut, client) = makeSUT(url)
        
        sut.transfer(jwtToken: "any token") { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_transfer_deliversErrorWithExpiredJWTToken() {
        let url = URL(string: "https://any-url.com/transfer")!
        let (sut, client) = makeSUT(url)
        let (failureResponse, json) = makeMakeTransferResponse(
            status: "failed",
            error: .init(
                name: "an error name",
                message: "an error message",
                tokenExpiredDate: "any date"
            )
        )
        
        let expectedResult = MakeTransferService.Result.success(failureResponse)
        sut.transfer(jwtToken: "an expired token") { actualResult in
            switch (actualResult, expectedResult) {
            case let (.success(actualResponse), .success(expectedResponse)):
                XCTAssertEqual(actualResponse, expectedResponse)
                
            default:
                XCTFail("Expected \(expectedResult), got \(actualResult)")
            }
        }
        client.complete(with: makeJSON(with: json))
    }
    
    func test_transfer_finishesSuccessfullyWithValidJWTToken() {
        let url = URL(string: "https://any-url.com/transfer")!
        let (sut, client) = makeSUT(url)
        let (successResponse, json) = makeMakeTransferResponse(
            status: "success",
            transactionId: "any transaction id",
            amount: 100,
            description: "any description",
            accountNumber: "an account number"
        )
        
        let expectedResult = MakeTransferService.Result.success(successResponse)
        sut.transfer(jwtToken: "an expired token") { actualResult in
            switch (actualResult, expectedResult) {
            case let (.success(actualResponse), .success(expectedResponse)):
                XCTAssertEqual(actualResponse, expectedResponse)
                
            default:
                XCTFail("Expected \(expectedResult), got \(actualResult)")
            }
        }
        client.complete(with: makeJSON(with: json))
    }
    
    //MARK: - Helpers
    
    private func makeSUT(_ url: URL = URL(string: "https://any-url.com")!) -> (sut: MakeTransferService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = MakeTransferService(url: url, client: client)
        return (sut, client)
    }
    
    private func makeMakeTransferResponse(
        status: String,
        transactionId: String? = nil,
        amount: Int? = nil,
        description: String? = nil,
        accountNumber: String? = nil,
        error: MakeTransferResponse.Error? = nil
    ) -> (response: MakeTransferResponse, json: [String: Any]) {
        let response = MakeTransferResponse(
            status: status,
            transactionId: transactionId,
            amount: amount,
            description: description,
            accountNumber: accountNumber,
            error: .init(
                name: error?.name,
                message: error?.message,
                tokenExpiredDate: error?.tokenExpiredDate
            )
        )
        
        let json: [String: Any] = [
            "status": status,
            "transactionId": transactionId,
            "amount": amount,
            "description": description,
            "recipientAccount": accountNumber,
            "error": [
                "name": error?.name,
                "message": error?.message,
                "expiredAt": error?.tokenExpiredDate
            ]
        ].compactMapValues { $0 }
        
        return (response, json)
    }
}
