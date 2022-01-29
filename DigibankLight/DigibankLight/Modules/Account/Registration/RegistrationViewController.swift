//
//  RegistrationViewController.swift
//  DigibankLight

import UIKit

class RegistrationViewController: UIViewController {
    
    private let backButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onBack: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}


//MARK: - Setup
extension RegistrationViewController {
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
            backButton.widthAnchor.constraint(equalToConstant: 40.0),
            backButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
}

//Actions
extension RegistrationViewController {
    
    @objc func back(_ sender: AnyObject) {
        onBack?()
    }
}
