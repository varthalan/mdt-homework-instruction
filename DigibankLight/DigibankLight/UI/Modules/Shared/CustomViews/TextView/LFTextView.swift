//
//  LFTextView.swift
//  DigibankLight
//

import UIKit

final class LFTextView: UIView {
    
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

    private(set) var textView: UITextView = {
        let textView = UITextView()
        textView.autocapitalizationType = .none
        textView.backgroundColor = .clear
        textView.textColor = .black
        textView.autocorrectionType = .no
        textView.font = .systemFont(ofSize: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private(set) var feedbackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    var text: String? {
        get {
            textView.text
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented to support")
    }
    
    func setupUI() {
        setupContainerView()
        setupFeedbackLabel()
        setupTitleLabel()
        setupTextView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapInView))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    func dismissEditing() {
        textView.resignFirstResponder()
    }
    
    func setText(_ text: String) {
        textView.text = text
        if text.isEmpty {
            dismissEditing()
        }
    }
}


//MARK: - Setup
extension LFTextView {
    private func setupContainerView() {
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0)
        ])
        containerView.makeRoundedCorners()
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
    
    private func setupTextView() {
        containerView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12.0),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12.0),
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -4.0),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4.0)
        ])
        configureTextViewWithDone()
    }
    
    private func configureTextViewWithDone() {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let flexible = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        let barButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(done))
        barButton.tintColor = .black
        toolBar.items = [flexible, barButton]
        textView.inputAccessoryView = toolBar

    }
}

//MARK: - Customization
extension LFTextView {
    
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
}

//MARK: - Actions
extension LFTextView {
    
    @objc func tapInView(_ sender: AnyObject) {
        textView.becomeFirstResponder()
    }
    
    @objc func done(_ sender: AnyObject) {
        textView.resignFirstResponder()
    }
}
