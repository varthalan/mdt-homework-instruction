//
//  RegistrationServiceTests.swift
//  DigibankLightTests
//

import XCTest
@testable import DigibankLight

struct RegistrationResponse: Equatable {
    let status: String
    let error: String
}

final class RegistrationServiceMapper {
    
    private struct Result: Decodable {
        let status: String
        let error: String
        
        var response: RegistrationResponse {
            RegistrationResponse(
                status: status,
                error: error)
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> RegistrationResponse {
        guard let registrationResponse = try? JSONDecoder().decode(Result.self, from: data) else {
            throw NSError(domain: "Parsing error in Registration response", code: 0)
        }
        return registrationResponse.response
    }
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
            switch result {
            case let  .success(value):
                do {
                    completion(.success(try  RegistrationServiceMapper.map(value.0, from: value.1)))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
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
    
    func test_createAccount_deliversErrorForExistingUser() {
        let url = URL(string: "https://any-url.com/register")!
        let (sut, client) = makeSUT(url)
        
        let (failedResponse, json) = makeRegistrationResponse(
            status: "failed",
            error: "any error")
        let expectedResponse = failedResponse
        
        let exp = expectation(description: "Wait for registration")
        sut.createAccount(for: "an existing username", password: "a password") { actualResponse in
            switch actualResponse {
            case let .success(returnedResponse):
                XCTAssertEqual(returnedResponse, expectedResponse)
                
            default:
                XCTFail("Expected \(expectedResponse), got \(actualResponse)")
            }
            exp.fulfill()
        }
        client.complete(with: makeJSON(with: json))
        
        wait(for: [exp], timeout: 1.0)
    }
    
    
    //MARK: - Helpers
    
    private func makeSUT(_ url: URL = URL(string: "https://any-url.com")!) -> (sut: RegistrationService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RegistrationService(url: url, client: client)
        return (sut, client)
    }
    
    private func makeRegistrationResponse(status: String, error: String) -> (response: RegistrationResponse, json: [String: String] ) {
        let response = RegistrationResponse(
            status: status,
            error: error
        )
        
        let json = [
            "status": status,
            "error": error
        ]
        
        return (response, json)
    }
    
    private func makeJSON(with json: [String: Any]) -> Data {
        try! JSONSerialization.data(withJSONObject: json)
    }

}
