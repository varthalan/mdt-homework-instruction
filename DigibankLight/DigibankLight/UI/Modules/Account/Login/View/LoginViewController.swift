//
//  LoginViewController.swift
//  DigibankLight
//

import UIKit

final class LoginViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 26, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    private let viewModel: LoginViewModel
    
    typealias Refresh = () -> Void
    var onRegister: (() -> Void)?
    var onLogin: ((String, String, Refresh?) -> Void)?
    
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
}

//MARK: - UI Setup
extension LoginViewController {
            
    private func setupUI() {
        setupTitleLabel()
        setupUsernameField()
        setupPasswordField()
        setupRegisterButton()
        setupLoginButtton()
    }

    private func setupTitleLabel() {
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 95.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        
        titleLabel.text = LoginViewModel.title
    }
    
    private func setupUsernameField() {
        view.addSubview(usernameField)
        NSLayoutConstraint.activate([
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            usernameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 170.0),
            usernameField.heightAnchor.constraint(equalToConstant: 84.0)
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
    
    private func setupRegisterButton() {
        view.addSubview(registerButton)
        NSLayoutConstraint.activate([
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40.0),
            registerButton.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        
        registerButton.setTitle(
            LoginViewModel.registerButtonTitle,
            for: .normal
        )
        registerButton.decorate(
            .white,
            textColor: .black,
            font: .systemFont(ofSize: 18, weight: .black),
            borderColor: .black,
            cornerRadius: 30.0,
            borderWidth: 1.0
        )
        registerButton.addTarget(
            self,
            action: #selector(register),
            for: .touchUpInside
        )
    }
    
    private func setupLoginButtton() {
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: registerButton.leadingAnchor),
            loginButton.widthAnchor.constraint(equalTo: registerButton.widthAnchor),
            loginButton.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -20.0),
            loginButton.heightAnchor.constraint(equalTo: registerButton.heightAnchor)
        ])
        loginButton.setTitle(LoginViewModel.loginButtonTitle, for: .normal)
        
        loginButton.decorate(
            .black,
            textColor: .white,
            font: .systemFont(ofSize: 18, weight: .black),
            borderColor: .black,
            cornerRadius: 30.0,
            borderWidth: 1.0
        )
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
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
                        
            self.onLogin?(username, jwtToken) { 
                self.usernameField.setText("")
                self.passwordField.setText("")
            }
        }
        
        viewModel.onLoginError = { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.showError(message: error)
            }
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
            usernameField.setFeedback(isUsernameEmpty ? LoginViewModel.usernameRequired : "")
            passwordField.setFeedback(isPasswordEmpty ? LoginViewModel.passwordRequired : "")
            return
        }
        
        viewModel.login(username: username, password: password)
    }
}
