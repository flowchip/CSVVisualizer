//
//  Date.swift
//  CSVVisualizer
//
//  Created by Ciprian Cojan on 19/07/21.
//

import Foundation

extension Date {
    func prettyDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        
        return formatter.string(from: self)
    }
}
