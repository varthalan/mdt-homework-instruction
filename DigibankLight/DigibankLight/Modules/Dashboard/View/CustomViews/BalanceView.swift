//
//  BalanceView.swift
//  DigibankLight
//

import UIKit

class BalanceView: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let youHaveLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = localize("you_have")
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) var balanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let accountNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = localize("account_no")
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) var accountNumberValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let accountHolderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = localize("account_holder")
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) var accountHolderValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)

        setupContainerView()
        setupYouHaveLabel()
        setupBalanceLabel()
        setupAccountNumberLabel()
        setupAccountNumberValueLabel()
        setupAccountHolderLabel()
        setupAccountHolderValueLabel()
    }
    
    private func setupContainerView() {
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
                
        setupRoundedCorners()
    }
    
    private func setupYouHaveLabel() {
        containerView.addSubview(youHaveLabel)
        NSLayoutConstraint.activate([
            youHaveLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            youHaveLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            youHaveLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30.0),
            youHaveLabel.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }
    
    private func setupBalanceLabel() {
        containerView.addSubview(balanceLabel)
        NSLayoutConstraint.activate([
            balanceLabel.leadingAnchor.constraint(equalTo: youHaveLabel.leadingAnchor),
            balanceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:  -16.0),
            balanceLabel.topAnchor.constraint(equalTo: youHaveLabel.bottomAnchor, constant: 5.0),
            balanceLabel.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }
    
    private func setupAccountNumberLabel() {
        containerView.addSubview(accountNumberLabel)
        NSLayoutConstraint.activate([
            accountNumberLabel.leadingAnchor.constraint(equalTo: balanceLabel.leadingAnchor),
            accountNumberLabel.widthAnchor.constraint(equalToConstant: 100),
            accountNumberLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 10.0),
            accountNumberLabel.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }
    
    private func setupAccountNumberValueLabel() {
        containerView.addSubview(accountNumberValueLabel)
        NSLayoutConstraint.activate([
            accountNumberValueLabel.leadingAnchor.constraint(equalTo: accountNumberLabel.leadingAnchor),
            accountNumberValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            accountNumberValueLabel.topAnchor.constraint(equalTo: accountNumberLabel.bottomAnchor, constant: 5.0),
            accountNumberValueLabel.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }

    private func setupAccountHolderLabel() {
        containerView.addSubview(accountHolderLabel)
        NSLayoutConstraint.activate([
            accountHolderLabel.leadingAnchor.constraint(equalTo: accountNumberValueLabel.leadingAnchor),
            accountHolderLabel.widthAnchor.constraint(equalToConstant: 120.0),
            accountHolderLabel.topAnchor.constraint(equalTo: accountNumberValueLabel.bottomAnchor, constant: 10.0),
            accountHolderLabel.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }
    
    private func setupAccountHolderValueLabel() {
        containerView.addSubview(accountHolderValueLabel)
        NSLayoutConstraint.activate([
            accountHolderValueLabel.leadingAnchor.constraint(equalTo: accountHolderLabel.leadingAnchor),
            accountHolderValueLabel.trailingAnchor.constraint(equalTo:containerView.trailingAnchor, constant: -16.0),
            accountHolderValueLabel.topAnchor.constraint(equalTo: accountHolderLabel.bottomAnchor, constant: 5.0),
            accountHolderValueLabel.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }
    
    private func setupRoundedCorners() {
        let maskLayer = CAShapeLayer()
        let frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width * 0.75, height: 240)
        maskLayer.frame = frame
        maskLayer.path = UIBezierPath(
            roundedRect: frame,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: .init(width: 20.0, height: 20.0)
        ).cgPath
        containerView.layer.mask = maskLayer
    }
}
