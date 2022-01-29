//
//  LFNonEditableTextFieldView.swift
//  DigibankLight
//

import UIKit

final class LFNonEditableTextFieldView: LFTextFieldView {
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "arrow"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func setupUI() {
        super.setupUI()
        textField.delegate = self

        setupArrowImage()
    }
    
    func setText(_ text: String) {
        textField.text = text
    }
    
    
    private func setupArrowImage() {
        textField.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            arrowImageView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 15.0),
            arrowImageView.heightAnchor.constraint(equalToConstant: 15.0),
            arrowImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        ])
    }
}

extension LFNonEditableTextFieldView {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
}

