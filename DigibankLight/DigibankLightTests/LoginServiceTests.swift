//
//  LoginServiceTests.swift
//  DigibankLightTests
//
//  Created by Nagaraju on 29/1/22.
//

import XCTest
@testable import DigibankLight

struct LoginResponse {
    
}

final class LoginService {
    
    private let url: URL
    private let client: HTTPClient
    
    typealias Result = Swift.Result<LoginResponse, Error>

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (Result) -> Void) {
        client.load(request: request()) { result in
            
        }
    }
    
    private func request() -> URLRequest {
        URLRequest(url: url)
    }
}

class LoginServiceTests: XCTestCase {
    
    func test_init_doesNotSendLoginRequest() {
        let client = HTTPClientSpy()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_sendsLoginRequest() {
        let url = URL(string: "https://any-url.com/login")!
        let client = HTTPClientSpy()
        let sut = LoginService(url: url, client: client)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }


    //MARK: - Helper
    
    private final class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        
        func load(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
            requestedURLs.append(request.url!)
        }

    }
}
