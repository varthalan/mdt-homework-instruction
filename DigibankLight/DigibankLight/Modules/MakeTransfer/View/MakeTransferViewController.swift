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
    
    private let descriptionField: LFTextView = {
        let view = LFTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var payeeName: String = "" {
        willSet {
            payeeField.setText(newValue)
        }
    }
    
    var payeeAccountNumber: String = ""

    typealias PayeeSelected = ((String, String) -> Void)
    
    var onBack: (() -> Void)?
    var onPayee: ((PayeeSelected?) -> Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stopEditing)))
    }
    
    override func setupUI() {
        super.setupUI()
        
        customizeParentSetup()
        setupPayeeField()
        setupAmountField()
        setupDescriptionField()
    }
    
}

//MARK: - Setup
extension MakeTransferViewController {
    
    private func setupPayeeField() {
        view.addSubview(payeeField)
        payeeField.delegate = self
        NSLayoutConstraint.activate([
            payeeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            payeeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            payeeField.topAnchor.constraint(equalTo: view.topAnchor, constant: 170.0),
            payeeField.heightAnchor.constraint(equalToConstant: 80.0)
        ])
        payeeField.setHeader(MakeTransferViewModel.payeeFieldTitle)
    }
    
    private func setupAmountField() {
        view.addSubview(amountField)
        NSLayoutConstraint.activate([
            amountField.leadingAnchor.constraint(equalTo: payeeField.leadingAnchor),
            amountField.widthAnchor.constraint(equalTo: payeeField.widthAnchor),
            amountField.topAnchor.constraint(equalTo: payeeField.bottomAnchor, constant: 20),
            amountField.heightAnchor.constraint(equalTo: payeeField.heightAnchor)
        ])
        amountField.setHeader(MakeTransferViewModel.amountFieldTitle)
        amountField.setFieldType(.number)
    }

    private func setupDescriptionField() {
        view.addSubview(descriptionField)
        
        NSLayoutConstraint.activate([
            descriptionField.leadingAnchor.constraint(equalTo: payeeField.leadingAnchor),
            descriptionField.widthAnchor.constraint(equalTo: payeeField.widthAnchor),
            descriptionField.topAnchor.constraint(equalTo: amountField.bottomAnchor, constant: 20.0),
            descriptionField.heightAnchor.constraint(equalToConstant: 150)
        ])
        descriptionField.setHeader(MakeTransferViewModel.descriptionFieldTitle)
    }
}

//MARK: - Customization
extension MakeTransferViewController {
    
    fileprivate func customizeParentSetup() {
        setTitle(MakeTransferViewModel.transferTitle)
        configureBottomActionButtonWith(
            title: MakeTransferViewModel.transferNowButtonTitle,
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
    
    @objc func stopEditing() {
        descriptionField.dismissEditing()
    }
    
}

extension MakeTransferViewController: LFNonEditableTextFieldViewDelegate {
    
    func onFieldBeginEditing() {
        onPayee?() { payeeName, payeeAccountNumber in
            self.payeeName = payeeName
            self.payeeAccountNumber = payeeAccountNumber
        }
    }
}
