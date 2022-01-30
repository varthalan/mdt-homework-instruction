//
//  String+DateExtension.swift
//  DigibankLight
//
//  Created by Nagaraju on 30/1/22.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.date(from: self)
    }
}
