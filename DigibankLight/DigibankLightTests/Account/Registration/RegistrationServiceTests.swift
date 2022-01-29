//
//  RegistrationServiceTests.swift
//  DigibankLightTests
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
