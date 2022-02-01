//
//  UIViewController+ErrorMessageExtensions.swift
//  DigibankLight
//

import UIKit

extension UIViewController {
    
    func showError(message: String, delay: TimeInterval = 2.0) {
        let container = UIView()
        container.backgroundColor = UIColor(red: 250.0/255.0, green: 228.0/255, blue: 227.0/255.0, alpha: 1.0)
        container.tag = 2001
        container.clipsToBounds = true
        container.layer.cornerRadius = 10.0
        container.layer.borderWidth = 2.0
        container.layer.borderColor = UIColor(red: 242.0/255.0, green: 169.0/255.0, blue: 167.0/255.0, alpha: 1.0).cgColor
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0.0
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150.0),
            container.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        
        let errorLabel = UILabel()
        errorLabel.backgroundColor = .clear
        errorLabel.textColor = .systemRed
        errorLabel.textAlignment = .left
        errorLabel.font = .systemFont(ofSize: 18, weight: .bold)
        errorLabel.adjustsFontSizeToFitWidth = true
        container.addSubview(errorLabel)
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.text = message
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.0),
            errorLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.0),
            errorLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8.0),
            errorLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8.0)
        ])

        
        UIView.animate(withDuration: 0.5) {
            container.alpha = 1.0
        } completion: { isCompleted in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                container.alpha = 0.0
                self.hideError()
            }
        }
    }
    
    private func hideError() {
        if let view = view.viewWithTag(2001) {
            view.removeFromSuperview()
        }
    }
}
