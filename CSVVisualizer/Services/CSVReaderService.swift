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
