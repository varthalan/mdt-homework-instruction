//
//  LoginViewController.swift
//  DigibankLight
//

import UIKit

class LoginViewController: UIViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
        registerButton.setTitleColor(.black, for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .black)
        registerButton.layer.cornerRadius = 35.0
        registerButton.layer.borderWidth = 2.0
        registerButton.layer.borderColor = UIColor.black.cgColor
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
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .black
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .black)
        loginButton.layer.cornerRadius = 35.0
        loginButton.layer.borderWidth = 2.0
        loginButton.layer.borderColor = UIColor.black.cgColor
    }
    
    private func setupUI() {
        setupUsernameField()
        setupPasswordField()
        setupRegisterButton()
        setupLoginButtton()
    }
}
