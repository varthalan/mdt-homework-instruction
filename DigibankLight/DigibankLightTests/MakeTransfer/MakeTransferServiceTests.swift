//
//  MakeTransferServiceTests.swift
//  DigibankLightTests
//

import XCTest

class MakeTransferServiceTests: XCTestCase {
    
    func test_init_doesNotInitiateTransfer() {
        let client = HTTPClientSpy()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
}
