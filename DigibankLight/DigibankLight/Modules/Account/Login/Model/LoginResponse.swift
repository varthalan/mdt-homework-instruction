//
//  LoginResponse.swift
//  DigibankLight
//

import Foundation

struct LoginResponse: Equatable {
    let status: String
    let jwtToken: String?
    let username: String?
    let accountNumber: String?
    let error: String?
}
