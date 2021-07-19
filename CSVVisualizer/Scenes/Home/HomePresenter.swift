//
//  HomePresenter.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 10/07/21.
//

import RxCocoa
import RxSwift
import RxOptional
import UIKit

protocol HomePresenterInput {
    var state: Observable<HomeState> { get }
}

final class HomePresenter: HomeViewControllerInput {
    var items: Driver<[IssueCellViewModel]>
    let error: Driver<String>
    
    init(input: HomePresenterInput) {
        items = input.state
            .map { $0.issues }
            .filterNil()
            .take(1)
            .map { issues in
                var items = [IssueCellViewModel(
                                name: issues.headers[safe: 0],
                                    surname: issues.headers[safe: 1],
                                    issuesCount: issues.headers[safe: 2],
                                    birth: issues.headers[safe: 3])]
                
                for item in issues.items {
                    items.append(IssueCellViewModel(
                                        name: item.name,
                                        surname: item.surname,
                                        issuesCount: item.issuesCount,
                                        birth: item.dateOfBirth))
                }
                
                return items
            }
            .asDriver(onErrorDriveWith: .never())
        
        error = input.state
            .map { $0.error }
            .filterNil()
            .asDriver(onErrorDriveWith: .never())
    }
}

extension Optional where Wrapped == String {
    func withoutQuotes() -> String? {
        let unwrapped = self ?? ""
        return String(unwrapped.dropFirst().dropLast())
    }
}

extension String {
    func withoutQuotes() -> String {
        guard count >= 3 else { return self }
        return String(dropFirst().dropLast())
    }
}
