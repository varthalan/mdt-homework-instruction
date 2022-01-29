//
//  RegistrationServiceTests.swift
//  DigibankLightTests
//

import XCTest
@testable import DigibankLight

struct RegistrationResponse {
    
}

final class RegistrationService {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func createAccount(for username: String, password: String, completion: @escaping (Swift.Result<RegistrationResponse, Error>) -> Void) {
        client.load(request: request()) { result in
            
        }
    }
    
    private func request() -> URLRequest {
        URLRequest(url: url)
    }
}

class RegistrationServiceTests: XCTestCase {

    func test_init_doesNotSendRegistrationRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_createAccount_sendsRequestToRegisterAccount() {
        let url = URL(string: "https://any-url.com/register")!
        let (sut, client) = makeSUT(url)
        
        sut.createAccount(for: "an username", password: "a password") { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    //MARK: - Helpers
    
    private func makeSUT(_ url: URL = URL(string: "https://any-url.com")!) -> (sut: RegistrationService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RegistrationService(url: url, client: client)
        return (sut, client)
    }
}
