//
//  AppDependency.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 10/07/21.
//

import Foundation

// The dependencies protocol defines what services it provides by adopting the services providers protocols
// i.e.: protocol AppDependencies: MyServiceProvider, MyManagerProvider { }
protocol AppDependencies:
    CSVReaderServiceProvider {}

/// Defines all the dependencies to be injected throughout the app.
class AppDependenciesProvider: AppDependencies {
    
    /// Holds the app dependencies singleton.
    static let provider = AppDependenciesProvider()

    // MARK: - Services
    lazy var csvReaderService: CSVReaderService = {
        return StandardCSVReaderService()
    }()
}
