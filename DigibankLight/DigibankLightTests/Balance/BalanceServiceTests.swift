//
//  BalanceServiceTests.swift
//  DigibankLightTests
//
//  Created by Nagaraju on 30/1/22.
//

import XCTest
@testable import DigibankLight


class BalanceServiceTests: XCTestCase {
    
    func test_init_doesNotSendRequestToRetrieveAccountBalance() {
        let client = HTTPClientSpy()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
}
