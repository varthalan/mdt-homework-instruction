//
//  MakeTransferViewController.swift
//  DigibankLight
//

import UIKit

final class MakeTransferViewController: UIViewController {
        
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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

    private(set) var bottomActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
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
    
    private var isMakeOtherTransferDismissed: Bool = false
    
    typealias Observer<T> = (T) -> Void
    typealias Empty = () -> Void
    typealias PayeeSelected = ((String, String) -> Void)
    
    var onBack: (Observer<Bool>)?
    var onPayee: (Observer<PayeeSelected?>)?
    var onJWTExpiry: (Empty)?
        
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
        view.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        setupUI()
    }
    
}

//MARK: - Setup
extension MakeTransferViewController {

    private func setupUI() {
        setupBackButton()
        setupTitleLabel()
        setupMakeTransferButton()
        setupScrollView()
        setupContainerView()
        setupPayeeField()
        setupAmountField()
        setupDescriptionField()
                
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
        
        titleLabel.text = MakeTransferViewModel.transferTitle
    }
    
    func setupMakeTransferButton() {
        view.addSubview(transferNowButton)
        
        NSLayoutConstraint.activate([
            transferNowButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            transferNowButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            transferNowButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40.0),
            transferNowButton.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        
        transferNowButton.setTitle(MakeTransferViewModel.transferNowButtonTitle, for: .normal)
        
        transferNowButton.decorate(
            .black,
            textColor: .white,
            font: .systemFont(ofSize: 18, weight: .black),
            borderColor: .black,
            cornerRadius: 30.0,
            borderWidth: 1.0
        )
        
        transferNowButton.addTarget(
            self,
            action: #selector(transfer),
            for: .touchUpInside
        )
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 170.0),
            scrollView.bottomAnchor.constraint(equalTo: transferNowButton.topAnchor, constant: -20.0)
        ])
    }
    

    private func setupContainerView() {
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
    }
    
    private func setupPayeeField() {
        containerView.addSubview(payeeField)
        payeeField.delegate = self
        NSLayoutConstraint.activate([
            payeeField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32.0),
            payeeField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32.0),
            payeeField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15.0),
            payeeField.heightAnchor.constraint(equalToConstant: 84.0)
        ])
        payeeField.setHeader(MakeTransferViewModel.payeeFieldTitle)
    }
    
    private func setupAmountField() {
        containerView.addSubview(amountField)
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
        containerView.addSubview(descriptionField)
        descriptionField.delegate = self
        NSLayoutConstraint.activate([
            descriptionField.leadingAnchor.constraint(equalTo: payeeField.leadingAnchor),
            descriptionField.widthAnchor.constraint(equalTo: payeeField.widthAnchor),
            descriptionField.topAnchor.constraint(equalTo: amountField.bottomAnchor, constant: 20.0),
            descriptionField.heightAnchor.constraint(equalToConstant: 150)
        ])
        descriptionField.setHeader(MakeTransferViewModel.descriptionFieldTitle)
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
        
        viewModel.onError = {  [weak self] message, isSessionExpired in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if isSessionExpired {
                    self.showError(message: "session expired", showOnTop: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.onJWTExpiry?()
                    }
                } else {
                    self.showError(message: message)
                }
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
            
            self.isMakeOtherTransferDismissed = true
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
        onBack?(isMakeOtherTransferDismissed)
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


extension MakeTransferViewController: LFTextViewDelegate {
    
    func textViewBeginEditing(_ isBegin: Bool) {
        if isBegin {
            scrollView.setContentOffset(.init(x: 0.0, y: 70.0), animated: true)
        } else {
            scrollView.setContentOffset(.zero, animated: true)
        }
    }
}
