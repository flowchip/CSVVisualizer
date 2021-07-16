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

//    mutating func safeRemove(at index: Int) {
//        guard index >= 0, index < count else { return }
//        remove(at: index)
//    }
//
//    mutating func safeInsert(_ newElement: Element, at position: Int) {
//        guard position >= 0, position <= count else { return }
//        insert(newElement, at: position)
//    }
}
