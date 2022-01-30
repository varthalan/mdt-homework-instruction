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
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadBalance_sendsRequestToRetrieveAccountBalance() {
        let url = URL(string: "https://any-url.com/balance")!
        let (sut, client) = makeSUT(url)
        
        sut.loadBalance(jwtToken: "any token") { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    //MARK: - Helpers
    
    private func makeSUT(_ url: URL = URL(string: "https://any-url.com")!) -> (sut: BalanceService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = BalanceService(url: url, client: client)
        return (sut, client)
    }
}
