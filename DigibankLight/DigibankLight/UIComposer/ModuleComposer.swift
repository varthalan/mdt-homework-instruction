//
//  ModuleComposer.swift
//  DigibankLight
//

import Foundation

final class ModuleComposer {
    
    static func composeLogin() -> LoginViewController {
        let viewModel = LoginViewModel()
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
