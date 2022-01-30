//
//  TransactionsServiceTests.swift
//  DigibankLightTests
//

import XCTest

class TransactionsServiceTests: XCTestCase {

    func test_init_doesNotSendRequestToLoadTransactions() {
        let client = HTTPClientSpy()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
}
