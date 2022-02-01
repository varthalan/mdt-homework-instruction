//
//  UIView+Styling.swift
//  DigibankLight
//

import UIKit

extension UIView {
    
    func makeRoundedCorners(color: UIColor = .black, width: CGFloat = 1.0, cornderRadius: CGFloat = 10.0) {
        clipsToBounds = true
        layer.cornerRadius = cornderRadius
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}
