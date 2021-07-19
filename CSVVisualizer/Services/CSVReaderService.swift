//
//  NetworkingService.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 10/07/21.
//

import RxSwift

protocol CSVReaderService {
    func fetchData() -> Single<Result<Issues, Error>>
}

protocol CSVReaderServiceProvider {
    var csvReaderService: CSVReaderService { get }
}

final class StandardCSVReaderService: CSVReaderService {
    let queue = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    func fetchData() -> Single<Result<Issues, Error>> {
        return Single.create { single in
            do {
                
                let filepath = Bundle.main.path(forResource: "issues", ofType: "csv") ?? ""
                let content = try String(contentsOfFile: filepath)
                let parsedCSV: [[String]] = content
                    .components(separatedBy: "\r\n")
                    .map { $0.components(separatedBy: ",") }
                
                let items = Array(parsedCSV.suffix(parsedCSV.count - 1))
                
                let issues = Issues(
                    headers: parsedCSV.first ?? [],
                    items: items.map { array in
                        return Issues.Issue(
                            name: array[safe: 0],
                            surname: array[safe: 1],
                            issuesCount: array[safe: 2],
                            dateOfBirth: array[safe: 3])
                        })

                single(.success(.success(issues)))
            } catch {
                single(.success(.failure(error)))
            }
            
            return Disposables.create()
        }
        .subscribe(on: queue)
    }
}

struct Issues {
    let headers: [String]
    let items: [Issue]
    
    struct Issue {
        let name: String?
        let surname: String?
        let issuesCount: String?
        let dateOfBirth: String?
    }
}
