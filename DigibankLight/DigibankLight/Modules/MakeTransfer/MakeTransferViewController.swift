//
//  MakeTransferViewController.swift
//  DigibankLight
//
//  Created by Nagaraju on 29/1/22.
//

import UIKit

class MakeTransferViewController: BaseViewController {
        
    private let payeesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var onBack: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func setupUI() {
        super.setupUI()
        setTitle("Transfer")
        addTarget(target: self, action: #selector(back))
        
        setupPayeesButton()
    }
}

//MARK: - Setup
extension MakeTransferViewController {
    
    private func setupPayeesButton() {
        view.addSubview(payeesButton)
        NSLayoutConstraint.activate([
            payeesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            payeesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            payeesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40.0),
            payeesButton.heightAnchor.constraint(equalToConstant: 70.0)
        ])
        
        payeesButton.setTitle("Transfer Now", for: .normal)
        payeesButton.decorateWith(
            .black,
            textColor: .white,
            font: .systemFont(ofSize: 20, weight: .black),
            borderColor: .black,
            cornerRadius: 35.0)
        
        payeesButton.addTarget(self, action: #selector(transfer), for: .touchUpInside)
    }
    
}

//MARK: - Actions
extension MakeTransferViewController {
    
    @objc func back(_ sender: AnyObject) {
        onBack?()
    }
    
    @objc func transfer(_ sender: AnyObject) {
        //API call
    }
    
}
