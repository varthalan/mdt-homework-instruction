//
//  Utilities.swift
//  DigibankLight
//

import Foundation

final class Utitlies {
    
    static func isSessionExpiredMessage(_ message: String) -> Bool {
        message == "TokenExpiredError"
    }
}
