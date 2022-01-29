//
//  MakeTransferViewController.swift
//  DigibankLight
//
//  Created by Nagaraju on 29/1/22.
//

import UIKit

class MakeTransferViewController: UIViewController {
    
    private let backButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setImage(UIImage(named: "back"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onBack: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension MakeTransferViewController {
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)

        setupBackButton()
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
}

extension MakeTransferViewController {
    
    @objc func back(_ sender: AnyObject) {
        onBack?()
    }
}
