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
    
    let queue = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    init(input: HomePresenterInput) {
        section = input.state
            .map { $0.issues }
            .filterNil()
            .observe(on: queue)
            .map { issues in
                let header = IssueViewModel(
                    name: issues.headers[safe: 0],
                    surname: issues.headers[safe: 1],
                    issuesCount: issues.headers[safe: 2],
                    birth: issues.headers[safe: 3],
                    style: .header)
                
                let items = issues.items.map { item -> IssueViewModel in
                    let birthDate = item.dateOfBirth?.getDate()
                    let birth = birthDate?.prettyDateTime()
                    
                    return IssueViewModel(
                        name: item.name,
                        surname: item.surname,
                        issuesCount: item.issuesCount,
                        birth: birth)
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


