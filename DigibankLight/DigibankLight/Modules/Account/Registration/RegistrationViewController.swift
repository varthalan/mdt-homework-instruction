//
//  RegistrationViewController.swift
//  DigibankLight

import UIKit

class RegistrationViewController: UIViewController {
    
    private let backButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .black)
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

    private let confirmPasswordField: LFTextFieldView = {
        let field = LFTextFieldView()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var onBack: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}


//MARK: - Setup
extension RegistrationViewController {
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        setupBackButton()
        setupTitleLabel()
        setupUsernameField()
        setupPasswordField()
        setupConfirmPasswordField()
        setupRegisterButton()
    }
    
    private func setupBackButton() {
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
            backButton.widthAnchor.constraint(equalToConstant: 40.0),
            backButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 95.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        
        titleLabel.text = "Register"
    }
    
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
    
    private func setupConfirmPasswordField() {
        view.addSubview(confirmPasswordField)
        NSLayoutConstraint.activate([
            confirmPasswordField.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            confirmPasswordField.widthAnchor.constraint(equalTo: passwordField.widthAnchor),
            confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            confirmPasswordField.heightAnchor.constraint(equalTo: passwordField.heightAnchor)
        ])
        confirmPasswordField.setHeader("Confirm Password")
        confirmPasswordField.setFieldType(.secured)
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
            .black,
            textColor: .white,
            font: .systemFont(ofSize: 20, weight: .black),
            borderColor: .black,
            cornerRadius: 35.0)
        
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
    }
}

//Actions
extension RegistrationViewController {
    
    @objc func back(_ sender: AnyObject) {
        onBack?()
    }
    
    @objc func register(_ sender: AnyObject) {
        //Validate equality for Password,Confirm password & Call API
    }
}
