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
    
    static func composeDashboardWith(
        balanceURL: URL,
        transactionsURL: URL,
        client: HTTPClient,
        accountHolderName: String,
        jwtToken: String
    ) -> DashboardViewController {
        let balanceService = BalanceService(
            url: balanceURL,
            client: client)

        let transactionsService = TransactionsService(
            url: transactionsURL,
            client: client
        )
        let viewModel = DashboardViewModel(
            balanceService: balanceService,
            transactionsService: transactionsService,
            accountHolderName: accountHolderName,
            jwtToken: jwtToken
        )
        return DashboardViewController(viewModel: viewModel)
    }
    
    static func composeMakeTransferWith(
        url: URL,
        jwtToken: String,
        client: HTTPClient) -> MakeTransferViewController {
        let service = MakeTransferService(url: url, client: client)
        let viewModel = MakeTransferViewModel(service: service, jwtToken: jwtToken)
        return MakeTransferViewController(viewModel: viewModel)
    }
    
    static func composePayeesWith(
        url: URL,
        jwtToken: String,
        client: HTTPClient) -> PayeesViewController {
            let service = PayeesService(
                url: url,
                client: client)
        let viewModel = PayeesViewModel(service: service, jwtToken: jwtToken)
            
        return PayeesViewController(viewModel: viewModel)
    }
}
