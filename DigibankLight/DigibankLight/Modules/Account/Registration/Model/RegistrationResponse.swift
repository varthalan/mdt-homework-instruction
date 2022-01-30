//
//  RegistrationResponse.swift
//  DigibankLight
//
//  Created by Nagaraju on 30/1/22.
//

import Foundation

struct RegistrationResponse: Equatable {
    let status: String
    let jwtToken: String?
    let error: String?
}
