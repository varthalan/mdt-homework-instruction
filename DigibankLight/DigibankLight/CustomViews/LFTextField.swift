//
//  LFTextField.swift
//  DigibankLight
//

import UIKit

enum LFTextFieldViewType {
    case normal
    case secured
    case number
}

//LFTextField - Labelled-Feedback TextField
class LFTextFieldView: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) var textField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.contentVerticalAlignment = .center
        textField.contentHorizontalAlignment = .left
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 18, weight: .black)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private(set) var feedbackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented to support")
    }
}


//MARK: - Setup

extension LFTextFieldView {
    private func setupContainerView() {
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0)
        ])
        setBorderColor()
    }
    
    private func setupFeedbackLabel() {
        addSubview(feedbackLabel)
        NSLayoutConstraint.activate([
            feedbackLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            feedbackLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            feedbackLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 6.0),
            feedbackLabel.heightAnchor.constraint(equalToConstant: 14.0)
        ])
    }
    
    private func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8.0),
            titleLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.25, constant: 0.0)
        ])
    }
    
    private func setupTextField() {
        containerView.addSubview(textField)
        textField.delegate = self
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -4.0),
            textField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.75, constant: 0.0)
        ])
        setFieldType(.normal)
    }
    
    private func setupUI() {
        setupContainerView()
        setupFeedbackLabel()
        setupTitleLabel()
        setupTextField()
    }
}

//MARK: - Customization
extension LFTextFieldView {
    func setBorderColor(_ color: UIColor = .black, width: CGFloat = 1.0) {
        containerView.layer.borderColor = color.cgColor
        containerView.layer.borderWidth = width
    }
    
    func setHeader(
        _ title: String,
        color: UIColor = .black,
        font: UIFont = .systemFont(ofSize: 14)) {
            titleLabel.text = title
            titleLabel.textColor = color
            titleLabel.font = font
    }

    func setFeedback(
        _ message: String,
        color: UIColor = .systemRed,
        font: UIFont = .systemFont(ofSize: 16)) {
            feedbackLabel.text = message
            feedbackLabel.textColor = color
            feedbackLabel.font = font
    }
    
    func setFieldType(_ type: LFTextFieldViewType) {
        switch type {
        case .normal:
            textField.keyboardType = .default
            
        case .secured:
            textField.isSecureTextEntry = true
            
        case .number:
            textField.keyboardType = .numbersAndPunctuation
        }
    }
}

extension LFTextFieldView: UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
