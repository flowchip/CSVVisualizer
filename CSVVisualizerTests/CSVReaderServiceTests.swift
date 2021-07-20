//
//  CSVReaderServiceTests.swift
//  CSVVisualizerTests
//
//  Created by Ciprian Cojan on 19/07/21.
//

import XCTest
import SwiftCSV
@testable import CSVVisualizer

class CSVReaderServiceTests: XCTestCase {
    var csvReaderService: StandardCSVReaderService!
    var bundle: Bundle!
    
    override func setUp() {
        super.setUp()
        csvReaderService = StandardCSVReaderService()
        bundle = Bundle(for: CSVReaderServiceTests.self)
    }
    
    func testHeader() throws {
        let expected = ["First name", "Sur name", "Issue count", "Date of birth"]
        
        csvReaderService.fetchData(fromIndex: 0, limitTo: 1, fileName: "issues", bundle: bundle) { result in
            switch result {
            case .success(let issues):
                XCTAssertEqual(expected, issues.headers)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testRows() throws {
        let expected = [["Theo","Jansen","5","1978-01-02T00:00:00"].getIssue(),
                        ["Fiona","de Vries","7","1950-11-12T00:00:00"].getIssue(),
                        ["Petra","Boersma","1","2001-04-20T00:00:00"].getIssue()]
        
        var index = 0
        
        csvReaderService.fetchData(fromIndex: 1, limitTo: 3, fileName: "issues", bundle: bundle) { result in
            print(index)
            switch result {
            case .success(let issues):
                let lhs = issues.items[safe: index]
                let rhs = expected.compactMap{ $0 }[safe: index]
                XCTAssertEqual(lhs,rhs)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            index += 1
        }
    }
    
    func testEmptyFields() throws {
        let expected = [Issues.Issue(name: "Theo", surname: "Jansen", issuesCount: "5", dateOfBirth: "1978-01-02T00:00:00"),
                        Issues.Issue(name: "Fiona", surname: "", issuesCount: "", dateOfBirth: nil),
                        Issues.Issue(name: "Ciro", surname: nil, issuesCount: nil, dateOfBirth: nil),
                        Issues.Issue(name: "", surname: "Boersma", issuesCount: nil, dateOfBirth: nil),]
        
        var index = 0
        
        csvReaderService.fetchData(fromIndex: 1, fileName: "empty_fields", bundle: bundle) { result in
            switch result {
            case .success(let issues):
                let lhs = issues.items[safe: index]
                let rhs = expected.compactMap{ $0 }[safe: index]
                XCTAssertEqual(lhs,rhs)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            index += 1
        }
    }
}
