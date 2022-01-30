//
//  ModuleComposer.swift
//  DigibankLight
//

import Foundation

final class ModuleComposer {
    
    static func composeLoginWith(url: URL, client: HTTPClient) -> LoginViewController {
        let loginService = LoginService(url: url, client: client)
        let viewModel = LoginViewModel(service: loginService)
        
        return LoginViewController(viewModel: viewModel)
    }
    
    static func composeRegistrationWith(
        registrationURL: URL,
        loginURL: URL,
        client: HTTPClient) -> RegistrationViewController {
            let registrationService = RegistrationService(url: registrationURL, client: client)
            let loginService = LoginService(url: loginURL, client: client)
            let registrationViewModel = RegistrationViewModel(registrationService: registrationService, loginService: loginService)
            
        return RegistrationViewController(viewModel: registrationViewModel)
    }
    
    static func composeDashboard() -> DashboardViewController {
        DashboardViewController()
    }
    
    static func composeMakeTransfer() -> MakeTransferViewController {
        MakeTransferViewController()
    }
    
    static func composePayees() -> PayeesViewController {
        PayeesViewController()
    }
}
