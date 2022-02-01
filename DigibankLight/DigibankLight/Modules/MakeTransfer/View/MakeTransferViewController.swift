//
//  MakeTransferViewController.swift
//  DigibankLight
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
    
    var onBack: ((Bool) -> Void)?
    var onPayee: ((PayeeSelected?) -> Void)?
    
    private let viewModel: MakeTransferViewModel
    
    init(viewModel: MakeTransferViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        bindViewModelEvents()
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
            payeeField.heightAnchor.constraint(equalToConstant: 84.0)
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

//MARK: - ViewModel Events

extension MakeTransferViewController {
    
    private func bindViewModelEvents() {
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                isLoading ? self.startLoading() : self.stopLoading()
            }
        }
        
        viewModel.onError = {  [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.showError(message: error)
            }
        }
        
        viewModel.onTransfer = { [weak self] response in
            guard let self = self,
                  let amount = response.amount else { return }
            
            DispatchQueue.main.async {
                self.showAlert(amount: amount)
            }
        }
    }
    
    private func showAlert(amount: Double) {
        let title = String(format: MakeTransferViewModel.successfulTransferAlertTitle, "$\(amount)", payeeName)
        let alert = UIAlertController(
            title: title,
            message: MakeTransferViewModel.successfulTransferAlertMessage,
            preferredStyle: .alert)

        let dashBoardAction = UIAlertAction(
            title: MakeTransferViewModel.gotoDashboardActionTitle,
            style: .cancel
        ) { [weak self] action in
            guard let self = self else { return }
            
            self.onBack?(true)
        }
        alert.addAction(dashBoardAction)

        let makeTransferAction = UIAlertAction(
            title: MakeTransferViewModel.makeTransferActionTitle,
            style: .default
        ) { [weak self] action in
            guard let self = self else { return }
            
            self.clearAllData()
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(makeTransferAction)
        
        present(alert, animated: true, completion: nil)
    }

    private func clearAllData() {
        self.payeeField.setText("")
        self.amountField.setText("")
        self.descriptionField.setText("")
        self.payeeName = ""
        self.payeeAccountNumber = ""
    }
}


//MARK: - Actions
extension MakeTransferViewController {
    
    @objc func back(_ sender: AnyObject) {
        onBack?(false)
    }
    
    @objc func transfer(_ sender: AnyObject) {
        guard let payeeName = payeeField.text,
              let payeeAmount = amountField.text else {
                  return
              }
        
        let isPayeeEmpty = payeeName.isEmpty && payeeAccountNumber.isEmpty
        let isAmountEmpty = payeeAmount.isEmpty
        
        if isPayeeEmpty || isAmountEmpty {
            payeeField.setFeedback(isPayeeEmpty ? MakeTransferViewModel.payeeFieldFeedback : "")
            amountField.setFeedback(isAmountEmpty ? MakeTransferViewModel.amountFieldFeedback : "")
            return
        }
        
        viewModel.makeTransfer(
            accountNumber: payeeAccountNumber,
            amount: payeeAmount,
            description: descriptionField.text
        )
    }
    
    @objc func stopEditing() {
        descriptionField.dismissEditing()
    }
    
}

//MARK: - LFNonEditableTextFieldViewDelegate protocol implementation
extension MakeTransferViewController: LFNonEditableTextFieldViewDelegate {
    
    func onFieldBeginEditing() {
        onPayee?() { payeeName, payeeAccountNumber in
            self.payeeName = payeeName
            self.payeeAccountNumber = payeeAccountNumber
        }
    }
}
