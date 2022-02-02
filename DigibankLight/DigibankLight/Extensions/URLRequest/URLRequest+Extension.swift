//
//  URLRequest+Extension.swift
//  DigibankLight
//
//  Created by Nagaraju on 2/2/22.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

extension URLRequest {
    static func makeRequest(
        with url: URL,
        method: HTTPMethod,
        jwtToken: String? = nil) -> URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            if let token = jwtToken {
                request.setValue(token, forHTTPHeaderField: "Authorization")
            }                
            return request
    }
}
