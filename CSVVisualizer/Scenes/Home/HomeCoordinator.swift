//
//  HomeCoordinator.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 10/07/21.
//

import UIKit

final class HomeCoordinator: NavigationCoordinator {
    var childrenCoordinators: [Coordinator] = []
    let viewController: UIViewController
    let navigationController: UINavigationController
    let dependencies: AppDependencies
    
    weak var delegate: CoordinatorDelegate?
    
    enum PresentationStyle {
        case pushed(title: String?)
        case asTab
    }

    init(dependencies: AppDependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        let interactor = HomeInteractor(dependencies: dependencies)
        let presenter = HomePresenter(input: interactor)
        let viewController = HomeViewController(input: presenter, output: interactor)
        self.navigationController = navigationController
        self.navigationController.viewControllers = [viewController]
        self.viewController = navigationController
    }
    
    func start() {}
}
