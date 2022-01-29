//
//  RegistrationServiceTests.swift
//  DigibankLightTests
//
//  Created by Nagaraju on 29/1/22.
//

import XCTest
@testable import DigibankLight

class RegistrationServiceTests: XCTestCase {

    func test_init_doesNotSendRegistrationRequest() {
        let client = HTTPClientSpy()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    //MARK: - Helpers
    
    final class HTTPClientSpy: HTTPClient {
        
        var requestedURLs = [URL]()
        
        func load(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
            
        }
        
    }
}
