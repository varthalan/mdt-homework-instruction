//
//  RegistrationViewController.swift
//  DigibankLight

import UIKit

final class RegistrationViewController: UIViewController {
        
    private let backButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setImage(UIImage(named: "back"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

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

    private let viewModel: RegistrationViewModel
    
    typealias Observer<T> = (T) -> Void
    typealias Empty = () -> Void
    var onBack: (Empty)?
    var onRegister: ((String, String) -> Void)?
    var onJWTExpiry: (Empty)?

    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        setupUI()
    }
}


//MARK: - Setup
extension RegistrationViewController {
    
    private func setupUI() {
        setupBackButton()
        setupTitleLabel()
        setupUsernameField()
        setupPasswordField()
        setupConfirmPasswordField()
        setupRegisterButton()
        bindViewModelEvents()
    }

    private func setupBackButton() {
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
            backButton.widthAnchor.constraint(equalToConstant: 40.0),
            backButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
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
        
        titleLabel.text = RegistrationViewModel.title
    }

    private func setupUsernameField() {
        view.addSubview(usernameField)
        NSLayoutConstraint.activate([
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            usernameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 170.0),
            usernameField.heightAnchor.constraint(equalToConstant: 84.0)
        ])
        usernameField.setHeader(RegistrationViewModel.usernameFieldTitle)
    }
    
    private func setupPasswordField() {
        view.addSubview(passwordField)
        NSLayoutConstraint.activate([
            passwordField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            passwordField.widthAnchor.constraint(equalTo: usernameField.widthAnchor),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            passwordField.heightAnchor.constraint(equalTo: usernameField.heightAnchor)
        ])
        passwordField.setHeader(RegistrationViewModel.passwordFieldTitle)
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
        confirmPasswordField.setHeader(RegistrationViewModel.confirmPasswordFieldTitle)
        confirmPasswordField.setFieldType(.secured)
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
            RegistrationViewModel.registerButtonTitle,
            for: .normal
        )
        registerButton.decorate(
            .black,
            textColor: .white,
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
}

//MARK: - ViewModel Events
extension RegistrationViewController {
    
    private func bindViewModelEvents() {
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                isLoading ? self.startLoading() : self.stopLoading()
            }
        }
        
        viewModel.onRegistrationSuccess = { [weak self] response in
            guard let self = self,
                  let jwtToken = response.jwtToken,
                  let username = response.username else { return }

            DispatchQueue.main.async {
                self.onRegister?(username, jwtToken)
            }
        }
        
        viewModel.onError = { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.showError(message: error)
            }
        }
    }
}


//MARK: - Actions
extension RegistrationViewController {
    
    @objc func back(_ sender: AnyObject) {
        onBack?()
    }
    
    @objc func register(_ sender: AnyObject) {
        guard let username = usernameField.text,
              let password = passwordField.text,
              let confirmPassword = confirmPasswordField.text else {
                  return
              }
        
        let isUsernameEmpty = username.isEmpty
        let isPasswordEmpty = password.isEmpty
        let isConfirmPasswordEmpty = confirmPassword.isEmpty
        
        if isUsernameEmpty || isPasswordEmpty ||  isConfirmPasswordEmpty {
            usernameField.setFeedback(isUsernameEmpty ? RegistrationViewModel.usernameRequired : "")
            passwordField.setFeedback(isPasswordEmpty ? RegistrationViewModel.passwordRequired : "")
            
            if (isConfirmPasswordEmpty && !isPasswordEmpty) {
                confirmPasswordField.setFeedback(RegistrationViewModel.passwordNotMatching)
            }
            
            if isConfirmPasswordEmpty && isPasswordEmpty {
                confirmPasswordField.setFeedback(RegistrationViewModel.confirmPasswordRequired)
            }
            return
        } else if password != confirmPassword {
            confirmPasswordField.setFeedback(RegistrationViewModel.passwordNotMatching)
            return
        }

        
        viewModel.registerWith(username: username, password: password)
    }
}
