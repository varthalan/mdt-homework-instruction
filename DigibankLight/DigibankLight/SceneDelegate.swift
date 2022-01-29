//
//  SceneDelegate.swift
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private lazy var loginViewController = ModuleComposer.composeLogin()
    private lazy var navigationController = UINavigationController(
        rootViewController: loginViewController)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
        configureNavigationController()
        bindEventsFromLogin()
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

//Navigations creation
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
}

//Modules creation
extension SceneDelegate {
    
    private func showRegistration() {
        let registrationViewController = ModuleComposer.composeRegistration()
        
        registrationViewController.onBack = { [weak self] in
            guard let self = self else { return }
            self.pop()
        }
        
        registrationViewController.onRegister = { [weak self] in
            guard let self = self else { return }
            
            self.showDashboard()
        }
        
        push(registrationViewController)
    }
    
    private func showDashboard() {
        let dashboardViewController = ModuleComposer.composeDashboard()
        
        dashboardViewController.onLogout = { [weak self] in
            guard let self = self else { return }
            
            self.popToRoot()
        }
        
        dashboardViewController.onMakeTransfer = { [weak self] in
            guard let self = self else { return }

            self.showMakeTransfer()
        }
        
        push(dashboardViewController)
    }
    
    private func showMakeTransfer() {
        let makeTransferViewController = ModuleComposer.composeMakeTransfer()
        
        makeTransferViewController.onBack = { [weak self] in
            guard let self = self else { return }
            
            self.pop()
        }
        
        push(makeTransferViewController)
    }
}


//Events listener
extension SceneDelegate {
    func bindEventsFromLogin() {
        
        loginViewController.onRegister = { [weak self] in
            guard let self = self else { return }
            self.showRegistration()
        }
        
        loginViewController.onLogin = { [weak self] in
            guard let self = self else { return }
            self.showDashboard()
        }
    }
}

