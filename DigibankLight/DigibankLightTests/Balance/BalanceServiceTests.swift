//
//  BalanceServiceTests.swift
//  DigibankLightTests
//
//  Created by Nagaraju on 30/1/22.
//

import XCTest
@testable import DigibankLight

final class BalanceService {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func loadBalance(jwtToken: String, completion: @escaping (Swift.Result<AnyObject, Error>) -> Void) {
        client.load(request: request()) { _ in }
    }
    
    private func request() -> URLRequest {
        URLRequest(url: url)
    }
}

class BalanceServiceTests: XCTestCase {
    
    func test_init_doesNotSendRequestToRetrieveAccountBalance() {
        let client = HTTPClientSpy()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadBalance_sendsRequestToRetrieveAccountBalance() {
        let url = URL(string: "https://any-url.com/balance")!
        let client = HTTPClientSpy()
        let sut = BalanceService(url: url, client: client)
        
        sut.loadBalance(jwtToken: "any token") { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
}
