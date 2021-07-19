//
//  HomeInteractor.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 10/07/21.
//

import RxCocoa
import RxSwift
import UIKit

protocol HomeInteractorDelegate: AnyObject {
//    func showArticle(_ article: Article)
}

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
    weak var delegate: HomeInteractorDelegate?
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        initialState = HomeState()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        default:
            return fetchNews()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.error = nil
        
        switch mutation {
        case .updateIssues(let issues):
            state.issues = issues
        case .setError(let error):
            state.error = error
        }
        
        return state
    }
    
    
    private func fetchNews() -> Observable<Mutation> {
        return dependencies.csvReaderService
            .fetchData()
            .asObservable()
            .map { result in
                switch result {
                case .success(let issues):
                    return .updateIssues(issues)
                case .failure(let error):
                    return .setError(error.localizedDescription)
                }
            }
    }
}
