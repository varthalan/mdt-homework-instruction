//
//  UIButton+Styling.swift
//  DigibankLight
//

import UIKit

extension UIButton {
    func decorate(
        _ color: UIColor = .black,
        textColor: UIColor = .white,
        font: UIFont,
        borderColor: UIColor,
        cornerRadius: CGFloat,
        borderWidth: CGFloat) {
        backgroundColor = color
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = font
        clipsToBounds = true
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
    }
}
