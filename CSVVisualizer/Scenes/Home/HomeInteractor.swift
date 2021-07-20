//
//  HomeInteractor.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 10/07/21.
//

import RxCocoa
import RxSwift
import UIKit

struct HomeState {
    var issues: Issues? = nil
    var error: String? = nil
}

final class HomeInteractor: HomeViewControllerOutput, HomePresenterInput, Reactor {
    typealias Action = HomeAction
    typealias State = HomeState

    enum Mutation {
        case updateIssues(Issues)
        case setError(String?)
    }

    let initialState: HomeState

    typealias Dependencies = CSVReaderServiceProvider
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        initialState = HomeState()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewLoaded:
            return fetchData()
        case .loadNextRows(let from):
            return fetchData(fromIndex: from)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.error = nil
        
        switch mutation {
        case .updateIssues(let issues):
            if var existingIssues = newState.issues, let lastAdded = issues.items.last {
                existingIssues.items.append(lastAdded)
                newState.issues = existingIssues
            } else {
                newState.issues = issues
            }
        case .setError(let error):
            newState.error = error
        }
        
        return newState
    }
    
    
    private func fetchData(fromIndex: Int = 0) -> Observable<Mutation> {
        return Observable.create { observer in
            self.dependencies.csvReaderService.fetchData(fromIndex: fromIndex, limitTo: fromIndex + 100, fileName: "issuesBig") { result in
                switch result {
                case .success(let issues):
                    observer.onNext(.updateIssues(issues))
                case .failure(let error):
                    observer.onNext(.setError(error.localizedDescription))
                }
            }
            return Disposables.create()
        }
    }
}
