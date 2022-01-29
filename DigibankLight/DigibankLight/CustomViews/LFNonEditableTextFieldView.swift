//
//  LFNonEditableTextFieldView.swift
//  DigibankLight
//

import UIKit

final class LFNonEditableTextFieldView: LFTextFieldView {
    
    override func setupUI() {
        super.setupUI()
        textField.delegate = self
        feedbackLabel.isHidden = true
    }
    
    func setText(_ text: String) {
        textField.text = text
    }
    
}

extension LFNonEditableTextFieldView {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
}

