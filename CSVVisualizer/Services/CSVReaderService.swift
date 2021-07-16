//
//  NetworkingService.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 10/07/21.
//

import RxSwift

protocol CSVReaderService {
    func fetchData() -> Single<Result<[String], Error>>
}

protocol CSVReaderServiceProvider {
    var csvReaderService: CSVReaderService { get }
}

final class StandardCSVReaderService: CSVReaderService {
    func fetchData() -> Single<Result<[String], Error>> {
        return .just(.success([]))
    }
}
