//
//  AppCoordinator.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 10/07/21.
//

import RxSwift
import UIKit

/// The app coordinator is the root coordinator of the app. It holds the app main window on which it sets the view controllers of the main scenes, and it holds the app dependencies object.
class AppCoordinator: RootCoordinator {
    let window: UIWindow
    let dependencies: AppDependencies
    var childrenCoordinators: [Coordinator] = []
    let navigationController = UINavigationController()
    let viewController: UIViewController

    init(with window: UIWindow, dependencies: AppDependencies) {
        self.window = window
        self.dependencies = dependencies
        viewController = navigationController
    }

    // MARK: - Start Functionalities
    func start() {
        showHomeScene()
        setupAppAppearance()
    }
    
    private func setupAppAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 71/256, green: 151/256, blue: 236/256, alpha: 1)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
    }
    
    func showHomeScene() {
        let coordinator = HomeCoordinator(dependencies: dependencies, navigationController: navigationController)
        switchTo(coordinator: coordinator)
    }
}
