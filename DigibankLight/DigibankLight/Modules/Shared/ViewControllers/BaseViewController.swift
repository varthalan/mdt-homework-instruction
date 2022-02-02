//
//  BaseViewController.swift
//  DigibankLight
//

import UIKit

class BaseViewController: UIViewController {
    
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
        label.font = .systemFont(ofSize: 30, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) var bottomActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    typealias Empty = () -> Void
    
    typealias Observer<T> = (T) -> Void
    var onJWTExpiry: (Empty)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        setupBackButton()
        setupTitleLabel()
        setupBottomActionButton()
    }

}

extension BaseViewController {
    
    private func setupBackButton() {
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
            backButton.widthAnchor.constraint(equalToConstant: 40.0),
            backButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 95.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }
    
    func setupBottomActionButton() {
        view.addSubview(bottomActionButton)
        
        NSLayoutConstraint.activate([
            bottomActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            bottomActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            bottomActionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40.0),
            bottomActionButton.heightAnchor.constraint(equalToConstant: 60.0)
        ])
    }
}


//MARK: - Customizations
extension BaseViewController {
    
    func setTitle(
        _ title: String,
        color: UIColor = .black,
        font: UIFont = .systemFont(ofSize: 26, weight: .bold)
    ) {
        titleLabel.text = title
        titleLabel.textColor = color
        titleLabel.font = font
    }
    
    func setTitleHidden(_ isHidden: Bool) {
        titleLabel.isHidden = true
    }
    
    func setBackButtonHidden(_ isHidden: Bool) {
        backButton.isHidden = isHidden
    }
    
    func configureBottomActionButtonWith(
        title: String,
        target: Any?,
        action: Selector,
        color: UIColor = .black,
        textColor: UIColor = .white,
        font: UIFont = .systemFont(ofSize: 18, weight: .black),
        borderColor: UIColor = .black,
        cornerRadius: CGFloat = 30.0,
        borderWidth: CGFloat = 1.0
    ) {
        bottomActionButton.setTitle(title, for: .normal)
        bottomActionButton.decorate(
            color,
            textColor: textColor,
            font: font,
            borderColor: borderColor,
            cornerRadius: cornerRadius,
            borderWidth: borderWidth
        )
        
        bottomActionButton.addTarget(self, action: action, for: .touchUpInside)
    }
}

//MARK: - Actions
extension BaseViewController {
    
    func addBackButtonTarget(target: Any?, action: Selector) {
        backButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

