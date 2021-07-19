//
//  String.swift
//  CSVVisualizer
//
//  Created by Ciprian Cojan on 19/07/21.
//

import Foundation

extension String {
    func withoutQuotes() -> String {
        guard count >= 3 else { return self }
        return String(dropFirst().dropLast())
    }
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self)
    }
}
