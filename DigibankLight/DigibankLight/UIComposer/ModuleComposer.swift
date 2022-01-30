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
    
    static func composeRegistration() -> RegistrationViewController {
        return RegistrationViewController()
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
