//
//  UIButton+Styling.swift
//  DigibankLight
//

import UIKit

extension UIButton {
    func decorateWith(_ color: UIColor, textColor: UIColor, font: UIFont, borderColor: UIColor, cornerRadius: CGFloat, borderWidth: CGFloat = 2.0) {
        backgroundColor = color
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = font
        clipsToBounds = true
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
    }
}
