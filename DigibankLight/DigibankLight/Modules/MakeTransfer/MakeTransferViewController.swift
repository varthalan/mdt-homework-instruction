//
//  MakeTransferViewController.swift
//  DigibankLight
//
//  Created by Nagaraju on 29/1/22.
//

import UIKit

class MakeTransferViewController: BaseViewController {
        
    private let transferNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let payeeField: LFNonEditableTextFieldView = {
        let field = LFNonEditableTextFieldView()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let amountField: LFTextFieldView = {
        let field = LFTextFieldView()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    
    var onBack: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func setupUI() {
        super.setupUI()
        
        customizeParentSetup()
        setupPayeeField()
        setupAmountField()
    }
}

//MARK: - Setup
extension MakeTransferViewController {
    
    private func setupPayeeField() {
        view.addSubview(payeeField)
        NSLayoutConstraint.activate([
            payeeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            payeeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            payeeField.topAnchor.constraint(equalTo: view.topAnchor, constant: 170.0),
            payeeField.heightAnchor.constraint(equalToConstant: 80.0)
        ])
        payeeField.setHeader("Payee")
    }
    
    private func setupAmountField() {
        view.addSubview(amountField)
        NSLayoutConstraint.activate([
            amountField.leadingAnchor.constraint(equalTo: payeeField.leadingAnchor),
            amountField.widthAnchor.constraint(equalTo: payeeField.widthAnchor),
            amountField.topAnchor.constraint(equalTo: payeeField.bottomAnchor, constant: 20),
            amountField.heightAnchor.constraint(equalTo: payeeField.heightAnchor)
        ])
        amountField.setHeader("Amount")
        amountField.setFieldType(.number)
    }

}

//MARK: - Customization
extension MakeTransferViewController {
    
    fileprivate func customizeParentSetup() {
        setTitle("Transfer")
        configureBottomActionButtonWith(
            title: "Transfer Now",
            target: self,
            action: #selector(transfer)
        )
        addBackButtonTarget(target: self, action: #selector(back))
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
