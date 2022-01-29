//
//  LoginServiceTests.swift
//  DigibankLightTests
//
//  Created by Nagaraju on 29/1/22.
//

import XCTest
@testable import DigibankLight

class LoginServiceTests: XCTestCase {
    
    func test_init_doesNotSendLoginRequest() {
        let client = HTTPClientSpy()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_sendsLoginRequest() {
        let url = URL(string: "https://any-url.com/login")!
        let client = HTTPClientSpy()
        let sut = LoginService(url: url, client: client)
        
        sut.load(username: "an username", password: "a password") { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_load_deliversFailureWithInvalidCredentials() {
        let url = URL(string: "https://any-url.com/login")!
        let client = HTTPClientSpy()
        let sut = LoginService(url: url, client: client)
        
        let (failureResponse, json) = makeLoginResponseWith(
            status: "failed",
            error: "any error"
        )
        
        let expectedResponse = LoginService.Result.success(failureResponse)
        
        let exp = expectation(description: "Wait for login completion")
        sut.load(username: "invalid user", password: "invalid password") { receivedResponse in
            switch (receivedResponse, expectedResponse) {
            case let (.success(receivedResult), .success(expectedResult)):
                XCTAssertEqual(receivedResult, expectedResult)
                
            default:
                XCTFail("Expected \(expectedResponse), got \(receivedResponse)")
            }
            exp.fulfill()
        }
        client.complete(with: makeJSON(with: json))
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_load_authenticatesWithValidCredentials() {
        let url = URL(string: "https://any-url.com/login")!
        let client = HTTPClientSpy()
        let sut = LoginService(url: url, client: client)
        
        let (successResponse, json) = makeLoginResponseWith(
            status: "success",
            jwtToken: "any token",
            username: "an username",
            accountNumber: "an account number"
        )
        
        let expectedResponse = LoginService.Result.success(successResponse)
        
        let exp = expectation(description: "Wait for login completion")
        sut.load(username: "valid user", password: "valid password") { receivedResponse in
            switch (receivedResponse, expectedResponse) {
            case let (.success(receivedResult), .success(expectedResult)):
                XCTAssertEqual(receivedResult, expectedResult)
                
            default:
                XCTFail("Expected \(expectedResponse), got \(receivedResponse)")
            }
            exp.fulfill()
        }
        client.complete(with: makeJSON(with: json))
        wait(for: [exp], timeout: 1.0)
    }

    //MARK: - Helper
    
    private func makeLoginResponseWith(
        status: String,
        jwtToken: String? = nil,
        username: String? = nil,
        accountNumber: String? = nil,
        error: String? = nil) -> (response: LoginResponse, json: [String: String]) {
            
        let response = LoginResponse(
            status: status,
            jwtToken: jwtToken,
            userName: username,
            accountNumber: accountNumber,
            error: error)
        
        let json = [
            "status": status,
            "token": jwtToken,
            "username": username,
            "accountNo": accountNumber,
            "error": error
        ].compactMapValues { $0 }
        
        return (response, json)
    }
    
    private func makeJSON(with json: [String: Any]) -> Data {
        try! JSONSerialization.data(withJSONObject: json)
    }
    
    private final class HTTPClientSpy: HTTPClient {
        private var messages = [(request: URLRequest, completion: (HTTPClient.Result) -> Void)]()
        
        var requestedURLs: [URL] {
            messages.map { $0.request.url! }
        }
        
        func load(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((request, completion))
        }
        
        func complete(with data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
            messages[index].completion(.success((data, response)))
        }

    }
}
