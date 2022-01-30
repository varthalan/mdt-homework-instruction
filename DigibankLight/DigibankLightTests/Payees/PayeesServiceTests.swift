//
//  PayeesServiceTests.swift
//  DigibankLightTests
//
//  Created by Nagaraju on 30/1/22.
//

import XCTest
@testable import DigibankLight

final class PayeesService {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(jwtToken: String, completion: @escaping () -> Void) {
        client.load(request: request()) { _ in }
    }
    
    private func request() -> URLRequest {
        URLRequest(url: url)
    }
}

class PayeesServiceTests: XCTestCase {
    
    func test_init_doesNotSendRequestToLoadPayees() {
        let client = HTTPClientSpy()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_sendsRequestToLoadPayees() {
        let url = URL(string: "https:any-url.com/payees")!
        let client = HTTPClientSpy()
        let sut = PayeesService(url: url, client: client)
        
        sut.load(jwtToken: "any token") { }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
}
