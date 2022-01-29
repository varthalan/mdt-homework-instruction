//
//  SharedTestHelpers.swift
//  DigibankLightTests
//

import Foundation
@testable import DigibankLight

final class HTTPClientSpy: HTTPClient {
    private var messages = [(request: URLRequest, completion: (HTTPClient.Result) -> Void)]()
    
    var requestedURLs: [URL] {
        messages.map { $0.request.url! }
    }
    
    func load(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        messages.append((request, completion))
    }
    
    func complete(with data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)!
        messages[index].completion(.success((data, response)))
    }

}
