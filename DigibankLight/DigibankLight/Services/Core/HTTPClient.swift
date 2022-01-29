//
//  HTTPClient.swift
//  DigibankLight
//

import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func load(request: URLRequest, completion: @escaping (Result) -> Void)
}
