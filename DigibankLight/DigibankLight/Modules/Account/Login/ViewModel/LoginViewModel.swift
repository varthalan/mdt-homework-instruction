//
//  LoginViewModel.swift
//  DigibankLight
//

import Foundation

final class LoginViewModel {
    
    private let service: LoginService
    
    typealias Observer<T> = (T) -> Void
    
    var onLoadingStateChange: Observer<Bool>?
    var onLoginSuccess: Observer<LoginResponse>?
    var onLoginError: Observer<String>?

    init(service: LoginService) {
        self.service = service
    }
    
    func login(username: String, password: String) {
        onLoadingStateChange?(true)
        service.login(username: username, password: password) { [weak self] result in
            guard let self = self else { return }
            
            self.onLoadingStateChange?(false)
            
            switch result {
            case let .success(response):
                if let error = response.error {
                    self.onLoginError?(error)
                } else {
                    self.onLoginSuccess?(response)
                }
                break
                
            case let .failure(error):
                self.onLoginError?(error.localizedDescription)
                break
            }
        }
    }
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
    
    static var usernameRequired: String {
        localize("username_required")
    }
    
    static var passwordRequired: String {
        localize("password_required")
    }
}

