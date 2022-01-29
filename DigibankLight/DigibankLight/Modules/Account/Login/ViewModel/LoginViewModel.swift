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
        localize("login_title")
    }
        
    static var usernameFieldTitle: String {
        localize("username_field_title")
    }
    
    static var passwordFieldTitle: String {
        localize("password_field_title")
    }
    
    static var registerButtonTitle: String {
        localize("register_button_title")
    }
    
    static var loginButtonTitle: String {
        localize("login_button_title")
    }
}

