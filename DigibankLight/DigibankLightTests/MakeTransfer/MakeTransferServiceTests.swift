//
//  MakeTransferServiceTests.swift
//  DigibankLightTests
//

import XCTest
@testable import DigibankLight

class MakeTransferServiceTests: XCTestCase {
    
    func test_init_doesNotInitiateTransfer() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_transfer_sendsRequestToTransfer() {
        let url = URL(string: "https://any-url.com/transfer")!
        let (sut, client) = makeSUT(url)
        
        sut.transfer(accountNumber: "any account number",
                     amount: 100,
                     jwtToken: "any token") { _ in }
        
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
        sut.transfer(accountNumber: "any account number",
                     amount: 100,
                     jwtToken: "an expired token") { actualResult in
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
        sut.transfer(accountNumber: "any account number",
                     amount: 100,
                     jwtToken: "any token") { actualResult in
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
