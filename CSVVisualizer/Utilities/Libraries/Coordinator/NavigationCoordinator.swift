//
//  NavigationCoordinator.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 11/07/21.
//

import UIKit

protocol NavigationProvider {
    var navigationController: UINavigationController { get }

    func push(child: Coordinator, animated: Bool)
    func pop(child: Coordinator, animated: Bool)
}

extension NavigationProvider where Self: Coordinator {
    func push(child: Coordinator, animated: Bool = true) {
        add(child: child)
        DispatchQueue.main.async {
            self.navigationController.pushViewController(child.viewController, animated: animated)
        }
    }
    
    func pop(child: Coordinator, animated: Bool = true) {
        if let coordinator = childrenCoordinators.first(where: { $0 === child }) {
            remove(child: coordinator)
            if coordinator.viewController.parent != nil {
                DispatchQueue.main.async {
                    self.navigationController.popViewController(animated: animated)
                }
            }
        }
    }
}

typealias NavigationCoordinator = Coordinator & NavigationProvider
