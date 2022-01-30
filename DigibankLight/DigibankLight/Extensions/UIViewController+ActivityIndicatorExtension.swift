//
//  UIViewController+ActivityIndicatorExtensions.swift
//  DigibankLight
//

import UIKit

extension UIViewController {
    
    func startLoading() {
        let container = UIView()
        container.backgroundColor = .black
        container.tag = 1001
        container.clipsToBounds = true
        container.layer.cornerRadius = 10.0
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.heightAnchor.constraint(equalToConstant: 80.0),
            container.widthAnchor.constraint(equalToConstant: 80.0)
        ])
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        container.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 30.0),
            activityIndicator.widthAnchor.constraint(equalToConstant: 30.0)
        ])
        
    }
    
    func stopLoading() {
        if let view = view.viewWithTag(1001) {
            view.removeFromSuperview()
        }
        view.isUserInteractionEnabled = true
    }
}
