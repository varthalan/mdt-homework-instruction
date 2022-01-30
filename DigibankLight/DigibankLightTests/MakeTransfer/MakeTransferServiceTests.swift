//
//  MakeTransferServiceTests.swift
//  DigibankLightTests
//

import XCTest

final class MakeTransferService {
    private let url: URL
    private let client: HTTPClientSpy
    
    init(url: URL, client: HTTPClientSpy) {
        self.url = url
        self.client = client
    }
    
    func transfer(jwtToken: String, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        client.load(request: request()) { _ in }
    }
    
    private func request() -> URLRequest {
        URLRequest(url: url)
    }
}

class MakeTransferServiceTests: XCTestCase {
    
    func test_init_doesNotInitiateTransfer() {
        let client = HTTPClientSpy()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_transfer_sendsRequestToTransfer() {
        let url = URL(string: "https://any-url.com/transfer")!
        let client = HTTPClientSpy()
        let sut = MakeTransferService(url: url, client: client)
        
        sut.transfer(jwtToken: "any token") { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
}
