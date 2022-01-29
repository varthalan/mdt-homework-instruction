//
//  LoginResponse.swift
//  DigibankLight
//
//  Created by Nagaraju on 29/1/22.
//

import Foundation

struct LoginResponse: Equatable {
    let status: String
    let jwtToken: String?
    let userName: String?
    let accountNumber: String?
    let error: String?
}
