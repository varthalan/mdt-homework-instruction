//
//  String+DateExtension.swift
//  DigibankLight
//

import Foundation

extension String {
    
    func shortDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_GB")
        guard let fullDate = formatter.date(from: self) else { return nil }
        formatter.dateFormat = "yyyy-MM-dd"
        let dateAsString = formatter.string(from: fullDate)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateAsString)
    }

}

