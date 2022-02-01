//
//  RegistrationViewController.swift
//  DigibankLight

import UIKit

final class RegistrationViewController: BaseViewController {
        
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
    
    var onBack: (() -> Void)?
    var onRegister: ((String, String) -> Void)?
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func setupUI() {
        super.setupUI()
        customizeParent()
        
        setupUsernameField()
        setupPasswordField()
        setupConfirmPasswordField()
        bindViewModelEvents()
    }
}


//MARK: - Setup
extension RegistrationViewController {

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
}

//MARK: - Customizations
extension RegistrationViewController {

    private func customizeParent() {
        setTitle(RegistrationViewModel.title)
        configureBottomActionButtonWith(
            title: RegistrationViewModel.registerButtonTitle,
            target: self,
            action: #selector(register)
        )
        addBackButtonTarget(target: self, action: #selector(back))
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
            
            if isConfirmPasswordEmpty && !isPasswordEmpty {
                confirmPasswordField.setFeedback(RegistrationViewModel.passwordNotMatching)
            }
            
            if isConfirmPasswordEmpty && isPasswordEmpty {
                confirmPasswordField.setFeedback(RegistrationViewModel.confirmPasswordRequired)
            }
            
            return
        }
        
        viewModel.registerWith(username: username, password: password)
    }
}
