//
//  Coordinator.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 11/07/21.
//

import UIKit
/**
 A coordinator is an object that bosses one or more view controllers around, taking all of the driving logic out of your view controllers. A coordinator presents/pushes/sets its children coordinators by presenting/pushing/setting their view controllers on its own view controller.

 This concept is based on the [Coordinators Design Pattern](http://khanlou.com/2015/10/coordinators-redux/) by Soroush Khanlou.
 */
protocol Coordinator: AnyObject {
    /// The list of the coordinator's children. All the children are coordinators too and each one represents a separate scene.
    var childrenCoordinators: [Coordinator] { get set }

    /// The roow view controller of the scene. It's the view controller which gets pushed, popped, shown modally etc.
    var viewController: UIViewController { get }

    /// Custom start method.
    func start()

    /// Presents a child scene modally.
    func present(child: Coordinator, animated: Bool, completion: (() -> Void)?)
    /// Dismisses a child scene modally.
    func dismiss(child: Coordinator, animated: Bool, completion: (() -> Void)?)
    /// Adds a new child to the coordinator's children list.
    func add(child: Coordinator)
    /// Adds new children to the coordinator's children list.
    func add(children: [Coordinator])
    /// Removes a child from the coordinator's children list.
    func remove(child: Coordinator)
    /// Removes children from the coordinator's children list.
    func remove(children: [Coordinator])
}

protocol CoordinatorDelegate: AnyObject {
    func dismiss(coordinator: Coordinator)
}

extension Coordinator {
    func add(child: Coordinator) {
        childrenCoordinators.append(child)
    }

    func add(children: [Coordinator]) {
        for child in children {
            childrenCoordinators.append(child)
        }
    }

    func remove(child: Coordinator) {
        childrenCoordinators.removeAll { $0 === child }
    }

    func remove(children: [Coordinator]) {
        for child in children {
            remove(child: child)
        }
    }

    func present(child: Coordinator, animated: Bool = true, completion: (() -> Void)? = nil) {
        add(child: child)
        DispatchQueue.main.async {
            self.viewController.present(child.viewController, animated: animated, completion: completion)
        }
    }

    func dismiss(child: Coordinator, animated: Bool = true, completion: (() -> Void)? = nil) {
        remove(child: child)
        DispatchQueue.main.async {
            child.viewController.dismiss(animated: animated, completion: completion)
        }
    }
    
    func getLastPushedCoordinator() -> Coordinator {
        var last: Coordinator = self
        for child in childrenCoordinators {
            last = child.getLastPushedCoordinator()
        }
        
        return last
    }
}
