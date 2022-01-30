//
//  LoginViewController.swift
//  DigibankLight
//

import UIKit

final class LoginViewController: BaseViewController {

    private let usernameField: LFTextFieldView = {
        let field = LFTextFieldView()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let passwordField: LFTextFieldView = {
        let field = LFTextFieldView()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let viewModel: LoginViewModel
    
    var onRegister: (() -> Void)?
    var onLogin: ((String, String) -> Void)?
        
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModelEvents()
    }

    
    override func setupUI() {
        super.setupUI()
        customizeParentSetup()
        
        setupUsernameField()
        setupPasswordField()
        setupLoginButtton()
    }
}

//MARK: - UI Setup
extension LoginViewController {
            
    private func setupUsernameField() {
        view.addSubview(usernameField)
        NSLayoutConstraint.activate([
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            usernameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 170.0),
            usernameField.heightAnchor.constraint(equalToConstant: 80.0)
        ])
        usernameField.setHeader(LoginViewModel.usernameFieldTitle)
    }
    
    private func setupPasswordField() {
        view.addSubview(passwordField)
        NSLayoutConstraint.activate([
            passwordField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            passwordField.widthAnchor.constraint(equalTo: usernameField.widthAnchor),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            passwordField.heightAnchor.constraint(equalTo: usernameField.heightAnchor)
        ])
        passwordField.setHeader(LoginViewModel.passwordFieldTitle)
        passwordField.setFieldType(.secured)
    }
    
    private func setupLoginButtton() {
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: bottomActionButton.leadingAnchor),
            loginButton.widthAnchor.constraint(equalTo: bottomActionButton.widthAnchor),
            loginButton.bottomAnchor.constraint(equalTo: bottomActionButton.topAnchor, constant: -20.0),
            loginButton.heightAnchor.constraint(equalTo: bottomActionButton.heightAnchor)
        ])
        loginButton.setTitle(LoginViewModel.loginButtonTitle, for: .normal)
        
        loginButton.decorate(
            .black,
            textColor: .white,
            font: .systemFont(ofSize: 20, weight: .black),
            borderColor: .black,
            cornerRadius: 35.0,
            borderWidth: 2.0
        )
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
}

//MARK: - Customizations
extension LoginViewController {

    private func customizeParentSetup() {
        setTitle(LoginViewModel.title)
        setBackButtonHidden(true)

        configureBottomActionButtonWith(
            title: LoginViewModel.registerButtonTitle,
            target: self,
            action: #selector(register),
            color: .white,
            textColor: .black,
            borderColor: .black
        )        
    }
    
}

//MARK: - ViewModel Events

extension LoginViewController {
    
    private func bindViewModelEvents() {
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                isLoading ? self.startLoading() : self.stopLoading()
            }
        }
        
        viewModel.onLoginSuccess = { [weak self] response in
            guard let self = self,
                  let jwtToken = response.jwtToken,
                  let username = response.username else { return }
                        
            self.onLogin?(username, jwtToken)
        }
        
        viewModel.onLoginError = { error in
            debugPrint("do something with - \(error).")
        }
    }
}

//MARK: - Actions

extension LoginViewController {
    
    @objc func register(_ sender: AnyObject) {
        onRegister?()
    }
    
    @objc func login(_ sender: AnyObject) {
            
        guard let username = usernameField.text,
              let password = passwordField.text else {
                  return
              }
        
        let isUsernameEmpty = username.isEmpty
        let isPasswordEmpty = password.isEmpty
        
        if isUsernameEmpty || isPasswordEmpty {
            usernameField.setFeedback(isUsernameEmpty ? localize("username_required") : "")
            passwordField.setFeedback(isPasswordEmpty ? localize("password_required") : "")
            return
        }
        
        viewModel.login(username: username, password: password)
    }
}
