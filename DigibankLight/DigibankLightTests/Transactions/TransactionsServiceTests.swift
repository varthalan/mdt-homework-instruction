//
//  TransactionsServiceTests.swift
//  DigibankLightTests
//

import XCTest
@testable import DigibankLight

final class TransactionsService {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(token: String, completion: @escaping () -> Void) {
        client.load(request: request()) { result in
            
        }
    }
    
    private func request() -> URLRequest {
        URLRequest(url: url)
    }
}

class TransactionsServiceTests: XCTestCase {

    func test_init_doesNotSendRequestToLoadTransactions() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_sendsRequestToLoadTransactions() {
        let url = URL(string: "https://any-url.com/transactions")!
        let (sut, client) = makeSUT(url)
        
        sut.load(token: "any token") { }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    //MARK: - Helpers
    
    private func makeSUT(_ url: URL = URL(string: "https://any-url.com")!) -> (sut: TransactionsService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = TransactionsService(url: url, client: client)
        return (sut, client)
    }
}
