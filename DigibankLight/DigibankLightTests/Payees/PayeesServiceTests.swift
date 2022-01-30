//
//  PayeesServiceTests.swift
//  DigibankLightTests
//
//  Created by Nagaraju on 30/1/22.
//

import XCTest

class PayeesServiceTests: XCTestCase {
    
    func test_init_doesNotSendRequestToLoadPayees() {
        let client = HTTPClientSpy()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
}
