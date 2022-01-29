//
//  NSLocalizedString+Extension.swift
//  DigibankLight
//

import Foundation

func localize(_ key: String, comment: String = "") -> String {
    NSLocalizedString(key, comment: comment)
}
