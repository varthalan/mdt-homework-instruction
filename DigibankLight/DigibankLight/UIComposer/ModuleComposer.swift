//
//  ModuleComposer.swift
//  DigibankLight
//

import Foundation

final class ModuleComposer {
    
    static func composeLogin() -> LoginViewController {
        return LoginViewController()
    }
    
    static func composeRegistration() -> RegistrationViewController {
        return RegistrationViewController()
    }
}
