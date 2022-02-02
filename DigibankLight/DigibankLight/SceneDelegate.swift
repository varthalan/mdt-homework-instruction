//
//  SceneDelegate.swift
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private lazy var navigationController = UINavigationController()
    
    var jwtToken: String?
    var username: String?

    var payeeSelectedAction: ((String, String) -> Void)?
    var dashboardRefreshAction: ((Bool) -> Void)?
    var loginRefreshAction: (() -> Void)?
    
    let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    
    private lazy var baseURL = URL(string: "https://green-thumb-64168.uc.r.appspot.com")!
                
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
        configureNavigationController()
        showLogin()
    }
    
    private func configureWindow() {
        window?.backgroundColor = .white
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func configureNavigationController() {
        navigationController.isNavigationBarHidden = true
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

//MARK: Navigations
extension SceneDelegate {

    private func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    private func pop() {
        navigationController.popViewController(animated: true)
    }
    
    private func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    private func present(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.present(viewController, animated: animated, completion: nil)
    }
    
    private func dismiss(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

//MARK: Modules creation
extension SceneDelegate {
    
    private func showLogin() {
        let loginViewController = ModuleComposer.composeLoginWith(
            url: APIEndPoint.login.url(baseURL: baseURL),
            client: client
        )
        
        loginViewController.onRegister = { [weak self] in
            guard let self = self else { return }
            
            self.showRegistration()
        }
        
        loginViewController.onLogin = { [weak self] username, jwtToken, action in
            guard let self = self else { return }
            
            self.username = username
            self.jwtToken = jwtToken
            self.loginRefreshAction = action
            
            DispatchQueue.main.async {
                self.showDashboard()
            }
        }
        
        navigationController.viewControllers = [loginViewController]
        window?.rootViewController = navigationController
    }
    
    private func showRegistration() {
        let registrationViewController = ModuleComposer.composeRegistrationWith(
            registrationURL: APIEndPoint.register.url(baseURL: baseURL),
            loginURL: APIEndPoint.login.url(baseURL: baseURL),
            client: client
        )
        
        registrationViewController.onBack = { [weak self] in
            guard let self = self else { return }
            self.pop()
        }
        
        registrationViewController.onRegister = { [weak self] username, jwtToken in
            guard let self = self else { return }
            
            self.username = username
            self.jwtToken = jwtToken
            
            self.showDashboard()
        }
        
        push(registrationViewController)
    }
    
    private func showDashboard() {
        guard let jwtToken = jwtToken,
              !jwtToken.isEmpty,
              let accountHolderName = username else { return }
        
        let dashboardViewController = ModuleComposer.composeDashboardWith(
            balanceURL: APIEndPoint.balance.url(baseURL: baseURL),
            transactionsURL: APIEndPoint.transactions.url(baseURL: baseURL),
            accountHolderName: accountHolderName,
            jwtToken: jwtToken,
            client: client
        )
        
        dashboardViewController.onLogout = { [weak self] in
            guard let self = self else { return }
                        
            self.resetSession()
            self.popToRoot()
        }
                
        dashboardViewController.onMakeTransfer = { [weak self] action in
            guard let self = self else { return }
            
            self.dashboardRefreshAction = action
            self.showMakeTransfer()
        }
        
        dashboardViewController.onJWTExpiry = { [weak self] in
            guard let self = self else { return }
            
            self.onJWTExpiry()
        }
        
        push(dashboardViewController)
    }
    
    private func showMakeTransfer() {
        guard let jwtToken = self.jwtToken,
              !jwtToken.isEmpty else { return }
        
        let makeTransferViewController = ModuleComposer.composeMakeTransferWith(
            url: APIEndPoint.transfer.url(baseURL: baseURL),
            jwtToken: jwtToken,
            client: client
        )
        
        makeTransferViewController.onBack = { [weak self] isRefreshNeeded in
            guard let self = self else { return }
            
            self.dashboardRefreshAction?(isRefreshNeeded)
            self.pop()
        }
            
        makeTransferViewController.onPayee = { [weak self] action in
            guard let self = self else { return }
            
            self.payeeSelectedAction = action
            self.showPayees()
        }
        
        makeTransferViewController.onJWTExpiry = { [weak self] in
            guard let self = self else { return }
            
            self.onJWTExpiry()
        }
        
        push(makeTransferViewController)
    }
    
    private func showPayees() {
        guard let jwtToken = self.jwtToken,
              !jwtToken.isEmpty else { return }
                
        let payeesViewController = ModuleComposer.composePayeesWith(
            url: APIEndPoint.payees.url(baseURL: baseURL),
            jwtToken: jwtToken,
            client: client)
        
        payeesViewController.onCancel = { [weak self] in
            guard let self = self else { return }
            
            self.dismiss(payeesViewController)
        }
        
        payeesViewController.onDone = { [weak self] payeeName, payeeAccountNumber in
            guard let self = self else { return }
                        
            self.payeeSelectedAction?(payeeName, payeeAccountNumber)
            self.dismiss(payeesViewController)
        }
        
        payeesViewController.onJWTExpiry = { [weak self] in
            guard let self = self else { return }
                        
            self.dismiss(payeesViewController, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                self.onJWTExpiry()
            }
        }
        
        let navigationController = UINavigationController(rootViewController: payeesViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController)
    }
    
    private func onJWTExpiry() {
        resetSession()
        popToRoot()
    }
    
    private func resetSession() {
        loginRefreshAction?()
        username = nil
        jwtToken = nil
        payeeSelectedAction = nil
        dashboardRefreshAction = nil
        loginRefreshAction = nil
    }
}
