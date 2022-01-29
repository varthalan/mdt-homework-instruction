//
//  URLSessionHTTPClient.swift
//  DigibankLight
//
//  Created by Nagaraju on 29/1/22.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func load(request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: request) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw NSError(domain: "Unexpected error", code: 0)
                }
            })
        }
    }
}
