//
//  Array.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 11/07/21.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return (Int(index) >= 0 && Int(index) < count) ? self[Int(index)] : nil
    }
}
