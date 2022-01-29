//
//  LoginViewModel.swift
//  DigibankLight
//
//  Created by Nagaraju on 29/1/22.
//

import Foundation

final class LoginViewModel {
    
    init() {}
}

//MARK: - Strings
extension LoginViewModel {
    static var title: String {
        NSLocalizedString("login_title", comment: "login")
    }
        
    static var usernameFieldTitle: String {
        NSLocalizedString("username_field_title", comment: "username")
    }
    
    static var passwordFieldTitle: String {
        NSLocalizedString("password_field_title", comment: "password")
    }
    
    static var registerButtonTitle: String {
        NSLocalizedString("register_button_title", comment: "register")
    }
    
    static var loginButtonTitle: String {
        NSLocalizedString("login_button_title", comment: "login")
    }
}

