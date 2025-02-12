//
//  PayeesServiceTests.swift
//  DigibankLightTests
//

import XCTest
@testable import DigibankLight

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
