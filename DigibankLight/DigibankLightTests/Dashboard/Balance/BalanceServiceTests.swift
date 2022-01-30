//
//  BalanceServiceTests.swift
//  DigibankLightTests
//
//  Created by Nagaraju on 30/1/22.
//

import XCTest
@testable import DigibankLight

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
    
    func test_loadBalance_deliversBalanceWithValidJWTToken() {
        let url = URL(string: "https://any-url.com/balance")!
        let (sut, client) = makeSUT(url)
        let (successResponse, json) = makeBalanceResponse(
            status: "success",
            accountNumber: "an account number",
            balance: 10000
        )
        
        let expectedResponse = BalanceService.Result.success(successResponse)
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
        accountNumber: String? = nil,
        balance: Int? = nil,
        error: BalanceResponse.Error? = nil
    ) -> (response: BalanceResponse, json: [String: Any]) {
        let response = BalanceResponse(
            status: status,
            accountNumber: accountNumber,
            balance: balance,
            error: .init(
                name: error?.name,
                message: error?.message,
                tokenExpiryDate: error?.tokenExpiryDate
            )
        )
        
        let json: [String: Any] = [
            "status": status,
            "accountNo": accountNumber,
            "balance": balance,
            "error": [
                "name": error?.name,
                "message": error?.message,
                "expiredAt": error?.tokenExpiryDate
            ]
        ].compactMapValues { $0 }
        
        return (response, json)
    }
}
