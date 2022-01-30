//
//  RegistrationServiceTests.swift
//  DigibankLightTests
//

import XCTest
@testable import DigibankLight

class RegistrationServiceTests: XCTestCase {

    func test_init_doesNotSendRegistrationRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_createAccount_sendsRequestToRegisterAccount() {
        let url = URL(string: "https://any-url.com/register")!
        let (sut, client) = makeSUT(url)
        
        sut.createAccount(for: "an username", password: "a password") { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_createAccount_deliversErrorForExistingUser() {
        let url = URL(string: "https://any-url.com/register")!
        let (sut, client) = makeSUT(url)
        
        let (failedResponse, json) = makeRegistrationResponse(
            status: "failed",
            error: "any error")
        
        let expectedResponse = RegistrationService.Result.success(failedResponse)
        let exp = expectation(description: "Wait for registration")
        sut.createAccount(for: "an existing username", password: "a password") { actualResponse in
            switch (actualResponse, expectedResponse) {
            case let (.success(returnedResult), .success(expectedResult)):
                XCTAssertEqual(returnedResult, expectedResult)
                
            default:
                XCTFail("Expected \(expectedResponse), got \(actualResponse)")
            }
            exp.fulfill()
        }
        client.complete(with: makeJSON(with: json))
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_createAccount_createsAccountForNewUser() {
        let url = URL(string: "https://any-url.com/register")!
        let (sut, client) = makeSUT(url)
        
        let (successResponse, json) = makeRegistrationResponse(
            status: "success",
            jwtToken: "any token"
        )
        
        let expectedResponse = RegistrationService.Result.success(successResponse)
        let exp = expectation(description: "Wait for registration")
        sut.createAccount(for: "a username", password: "a password") { actualResponse in
            switch (actualResponse, expectedResponse) {
            case let (.success(returnedResult), .success(expectedResult)):
                XCTAssertEqual(returnedResult, expectedResult)
                
            default:
                XCTFail("Expected \(expectedResponse), got \(actualResponse)")
            }
            exp.fulfill()
        }
        client.complete(with: makeJSON(with: json))
        
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(_ url: URL = URL(string: "https://any-url.com")!) -> (sut: RegistrationService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RegistrationService(url: url, client: client)
        return (sut, client)
    }
    
    private func makeRegistrationResponse(
        status: String,
        jwtToken: String? = nil,
        error: String? = nil) -> (response: RegistrationResponse, json: [String: String] ) {
        let response = RegistrationResponse(
            status: status,
            jwtToken: jwtToken,
            error: error
        )
        
        let json = [
            "status": status,
            "token": jwtToken,
            "error": error
        ].compactMapValues { $0 }
        
        return (response, json)
    }
}
