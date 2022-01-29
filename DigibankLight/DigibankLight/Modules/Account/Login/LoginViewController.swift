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
    
    var onRegister: (() -> Void)?
    var onLogin: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
    
    private func setupLoginButtton() {
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: bottomActionButton.leadingAnchor),
            loginButton.widthAnchor.constraint(equalTo: bottomActionButton.widthAnchor),
            loginButton.bottomAnchor.constraint(equalTo: bottomActionButton.topAnchor, constant: -20.0),
            loginButton.heightAnchor.constraint(equalTo: bottomActionButton.heightAnchor)
        ])
        loginButton.setTitle("LOGIN", for: .normal)
        
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
        setTitle("Login")
        setBackButtonHidden(true)

        configureBottomActionButtonWith(
            title: "REGISTER",
            target: self,
            action: #selector(register),
            color: .white,
            textColor: .black,
            borderColor: .black
        )        
    }
    
}

//MARK: - Actions

extension LoginViewController {
    
    @objc func register(_ sender: AnyObject) {
        onRegister?()
    }
    
    @objc func login(_ sender: AnyObject) {
        //Call API
        onLogin?()
    }
}
