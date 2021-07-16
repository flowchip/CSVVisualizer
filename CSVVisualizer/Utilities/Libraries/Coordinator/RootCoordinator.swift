//
//  RootCoordinator.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 11/07/21.
//

import UIKit

/// A root coordinator is a special coordinator which holds a UIWindow.
typealias RootCoordinator = Coordinator & WindowProvider

protocol WindowProvider: AnyObject {
    var window: UIWindow { get }
}

extension WindowProvider where Self: Coordinator {
    func switchTo(coordinator: Coordinator) {
        remove(children: childrenCoordinators)
        add(child: coordinator)
        window.rootViewController = coordinator.viewController
        window.makeKeyAndVisible()
        coordinator.start()
    }
}
