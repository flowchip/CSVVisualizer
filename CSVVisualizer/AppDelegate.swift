//
//  CSVVisualizerTests.swift
//  AppDelegate
//
//  Created by Ciprian Cojan on 16/07/21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppCoordinator()
        return true
    }

    private func setupAppCoordinator() {
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(with: window!, dependencies: AppDependenciesProvider.provider)
        appCoordinator?.start()
    }
}

