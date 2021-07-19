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
    var section: Driver<IssuesSection>
    let error: Driver<String>
    
    init(input: HomePresenterInput) {
        section = input.state
            .map { $0.issues }
            .filterNil()
            .take(1)
            .map { issues in
                let header = IssueViewModel(
                    name: issues.headers[safe: 0],
                    surname: issues.headers[safe: 1],
                    issuesCount: issues.headers[safe: 2],
                    birth: issues.headers[safe: 3],
                    style: .header)
                
                let items = issues.items.dropFirst().map {
                    IssueViewModel(
                        name: $0.name,
                        surname: $0.surname,
                        issuesCount: $0.issuesCount,
                        birth: $0.dateOfBirth)
                }
                
                return IssuesSection(header: header, items: items)
            }
            .asDriver(onErrorDriveWith: .never())
        
        error = input.state
            .map { $0.error }
            .filterNil()
            .asDriver(onErrorDriveWith: .never())
    }
}

struct IssuesSection {
    let header: IssueViewModel
    let items: [IssueViewModel]
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
