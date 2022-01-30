//
//  RegistrationViewModel.swift
//  DigibankLight
//

import Foundation

final class RegistrationViewModel {
    private let registrationService: RegistrationService
    private let loginService: LoginService
    
    typealias Observer<T> = (T) -> Void
    var onLoadingStateChange: Observer<Bool>?
    var onRegistrationSuccess: Observer<LoginResponse>?
    var onError: Observer<String>?

    init(registrationService: RegistrationService, loginService: LoginService) {
        self.registrationService = registrationService
        self.loginService = loginService
    }

    func registerWith(username: String, password: String) {
        onLoadingStateChange?(true)
        registrationService.createAccount(for: username, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(response):
                if let error = response.error {
                    self.onError?(error)
                } else {
                    self.login(username: username, password: password)
                }
                
            case let .failure(error):
                self.onLoadingStateChange?(false)
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    private func login(username: String, password: String) {
        loginService.login(username: username, password: password) { [weak self] result in
            guard let self = self else { return }

            self.onLoadingStateChange?(false)
            
            switch result {
            case let .success(response):
                if let error = response.error {
                    self.onError?(error)
                } else {
                    self.onRegistrationSuccess?(response)
                }
                
            case let .failure(error):
                self.onError?(error.localizedDescription)
            }
        }
    }

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
    
    static var usernameRequired: String {
        localize("username_required")
    }
    
    static var passwordRequired: String {
        localize("password_required")
    }

    static var confirmPasswordRequired: String {
        localize("confirm_password_required")
    }
    
    static var passwordNotMatching: String {
        localize("password_not_matching")
    }

}
