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
    var issues: Driver<Issues>
    let error: Driver<String>
    
    init(input: HomePresenterInput) {
        issues = input.state
            .map { $0.issues }
            .filterNil()
            .take(1)
            .asDriver(onErrorDriveWith: .never())
        
        error = input.state
            .map { $0.error }
            .filterNil()
            .asDriver(onErrorDriveWith: .never())
    }
}
