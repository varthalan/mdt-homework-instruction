//
//  RegistrationViewModel.swift
//  DigibankLight
//

import Foundation

final class RegistrationViewModel {
    init() {}
}

//MARK: - Strings
extension RegistrationViewModel {
    
    static var title: String {
        localize("registration_title")
    }
    
    static var usernameFieldTitle: String {
        localize("username_field_title")
    }
    
    static var passwordFieldTitle: String {
        localize("password_field_title")
    }
    
    static var confirmPasswordFieldTitle: String {
        localize("confirm_password_field_title")
    }

    static var registerButtonTitle: String {
        localize("register_button_title")
    }
}
