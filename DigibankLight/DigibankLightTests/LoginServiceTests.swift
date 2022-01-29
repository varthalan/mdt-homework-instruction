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
    

    //MARK: - Helper
    
    private final class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        
        func load(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        }

    }
}
