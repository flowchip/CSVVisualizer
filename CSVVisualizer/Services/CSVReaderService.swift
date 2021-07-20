//
//  NetworkingService.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 10/07/21.
//

import SwiftCSV

protocol CSVReaderService {
    func fetchData(fromIndex: Int, limitTo: Int?, fileName: String, bundle: Bundle, _ block: @escaping (Result<Issues, Error>) -> Void)
}

protocol CSVReaderServiceProvider {
    var csvReaderService: CSVReaderService { get }
}

final class StandardCSVReaderService: CSVReaderService {
    
    func fetchData(fromIndex: Int, limitTo: Int?, fileName: String, bundle: Bundle, _ block: @escaping (Result<Issues, Error>) -> Void) {
        do {
            let csvURL = bundle.url(forResource: fileName, withExtension: "csv")!
            let csv = try CSV(url: csvURL)
            
            var issues = Issues(headers: csv.header, items: [])
            var items = [Issues.Issue]()
            
            try csv.enumerateAsArray(limitTo: limitTo, startAt: fromIndex) { array in
                let issue = array.getIssue()
                let newBlock = array == csv.header || issue != nil
                
                if array != csv.header, let issue = issue {
                    items.append(issue)
                    issues.items = items
                }
                
                if newBlock {
                    block(.success(issues))
                }
            }
        } catch {
            block(.failure(error))
        }
    }
}

extension CSVReaderService {
    func fetchData(fromIndex: Int = 0,
                   limitTo: Int? = nil,
                   fileName: String = "issues",
                   bundle: Bundle = Bundle(for: StandardCSVReaderService.self),
                   _ block: @escaping (Result<Issues, Error>) -> Void) {
        return fetchData(fromIndex: fromIndex, limitTo: limitTo, fileName: fileName, bundle: bundle, block)
    }
}

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
