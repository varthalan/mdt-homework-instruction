//
//  RegistrationResponse.swift
//  DigibankLight
//

import Foundation

struct RegistrationResponse: Equatable {
    let status: String
    let jwtToken: String?
    let error: String?
}
