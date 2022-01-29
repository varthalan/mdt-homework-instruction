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
    
    private func setupUI() {
        setupUsernameField()
        setupPasswordField()
    }
}
