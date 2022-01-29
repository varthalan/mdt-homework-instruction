//
//  DashboardViewController.swift
//  DigibankLight
//
//  Created by Nagaraju on 29/1/22.
//

import UIKit

class DashboardViewController: BaseViewController {
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    var onLogout: (() -> Void)?
    var onMakeTransfer: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func setupUI() {
        super.setupUI()
        customizeParent()
        
        setupLogoutButton()
    }
}


//MARK: - Setup
extension DashboardViewController {
    
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
}

//MARK: - Customizations
extension DashboardViewController {
    
    private func customizeParent() {
        setTitleHidden(true)
        setBackButtonHidden(true)
        
        configureBottomActionButtonWith(
            title: "Make Transfer",
            target: self,
            action: #selector(makeTransfer)
        )
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
