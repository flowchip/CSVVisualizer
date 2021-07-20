//
//  Issues.swift
//  CSVVisualizer
//
//  Created by Ciprian Cojan on 20/07/21.
//

import Foundation

struct Issues {
    let headers: [String]
    var items: [Issue]
    
    struct Issue: Equatable {
        let name: String?
        let surname: String?
        let issuesCount: String?
        let dateOfBirth: String?
        
        static func ==(lhs: Issue, rhs: Issue) -> Bool {
            return lhs.name == rhs.name &&
                lhs.surname == rhs.surname &&
                lhs.issuesCount == rhs.issuesCount &&
                lhs.dateOfBirth == rhs.dateOfBirth
        }
    }
}

extension Array where Element == String {
    func getIssue() -> Issues.Issue? {
        guard self.count > 0, self[safe: 0]?.isNotEmpty ?? false else { return nil }
        
        return Issues.Issue(
            name: self[safe: 0],
            surname: self[safe: 1],
            issuesCount: self[safe: 2],
            dateOfBirth: self[safe: 3])
    }
}
