//
//  LoginViewController.swift
//  DigibankLight
//

import UIKit

class LoginViewController: BaseViewController {

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
    
    var onRegister: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func setupUI() {
        super.setupUI()
        
        setTitle("Login")
        setBackButtonHidden(true)
        
        setupUsernameField()
        setupPasswordField()
        setupRegisterButton()
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
        usernameField.setHeader("Username")
    }
    
    private func setupPasswordField() {
        view.addSubview(passwordField)
        NSLayoutConstraint.activate([
            passwordField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            passwordField.widthAnchor.constraint(equalTo: usernameField.widthAnchor),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            passwordField.heightAnchor.constraint(equalTo: usernameField.heightAnchor)
        ])
        passwordField.setHeader("Password")
        passwordField.setFieldType(.secured)
    }
    
    private func setupRegisterButton() {
        view.addSubview(registerButton)
        NSLayoutConstraint.activate([
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40.0),
            registerButton.heightAnchor.constraint(equalToConstant: 70.0)
        ])
        
        registerButton.setTitle("REGISTER", for: .normal)
        registerButton.decorateWith(
            .white,
            textColor: .black,
            font: .systemFont(ofSize: 20, weight: .black),
            borderColor: .black,
            cornerRadius: 35.0)
        
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
    }
    
    private func setupLoginButtton() {
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: registerButton.leadingAnchor),
            loginButton.widthAnchor.constraint(equalTo: registerButton.widthAnchor),
            loginButton.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -20.0),
            loginButton.heightAnchor.constraint(equalTo: registerButton.heightAnchor)
        ])
        loginButton.setTitle("LOGIN", for: .normal)
        
        loginButton.decorateWith(
            .black,
            textColor: .white,
            font: .systemFont(ofSize: 20, weight: .black),
            borderColor: .black,
            cornerRadius: 35.0)
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
}

//MARK: - Actions

extension LoginViewController {
    
    @objc func register(_ sender: AnyObject) {
        onRegister?()
    }
    
    @objc func login(_ sender: AnyObject) {
        //Call API
    }
}
