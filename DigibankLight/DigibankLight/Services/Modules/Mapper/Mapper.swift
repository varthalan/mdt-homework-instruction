//
//  Mapper.swift
//  DigibankLight
//

import Foundation

struct Mapper<Result: Decodable> {
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> Result {
        guard let result = try? JSONDecoder().decode(Result.self, from: data) else {
            throw NSError(domain: "Parsing error while mapping \(Result.self)", code: 0)
        }
        
        return result
    }
}
