//
//  DashboardViewController.swift
//  DigibankLight
//
//  Created by Nagaraju on 29/1/22.
//

import UIKit

class DashboardViewController: UIViewController {
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let makeTransferButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    var onLogout: (() -> Void)?
    var onMakeTransfer: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}


//MARK: - Setup
extension DashboardViewController {
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        setupLogoutButton()
        setupMakeTransferButton()
    }
    
    private func setupLogoutButton() {
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 60.0),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
            logoutButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    private func setupMakeTransferButton() {
        view.addSubview(makeTransferButton)
        NSLayoutConstraint.activate([
            makeTransferButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            makeTransferButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            makeTransferButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40.0),
            makeTransferButton.heightAnchor.constraint(equalToConstant: 70.0)
        ])
        
        makeTransferButton.setTitle("Make Transfer", for: .normal)
        makeTransferButton.decorateWith(
            .black,
            textColor: .white,
            font: .systemFont(ofSize: 20, weight: .black),
            borderColor: .black,
            cornerRadius: 35.0)
        
        makeTransferButton.addTarget(self, action: #selector(makeTransfer), for: .touchUpInside)
    }
}

//MARK: - Actions
extension DashboardViewController {
    
    @objc func logout(_ sender: AnyObject) {
        onLogout?()
    }
    
    @objc func makeTransfer(_ sender: AnyObject) {
        onMakeTransfer?()
    }
}
