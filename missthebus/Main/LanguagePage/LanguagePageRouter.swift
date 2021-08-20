//
//  LanguagePageRouter.swift
//  missthebus
//
//  Created by Matthew Siu on 20/8/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - The main interface to be called by others
protocol LanguagePageRoutingLogic
{
    func restartApp()
}

// MARK: - The possible elements that can be
protocol LanguagePageDataPassing
{
    var dataStore: LanguagePageDataStore? { get }
}

// MARK: - Main router body
class LanguagePageRouter: NSObject, LanguagePageRoutingLogic, LanguagePageDataPassing
{
    weak var viewController: LanguagePageViewController?
    var dataStore: LanguagePageDataStore?
    
    func restartApp(){
        let request = SplashScreenBuilder.BuildRequest()
        let vc = SplashScreenBuilder.createScene(request: request)
        guard let window = UIApplication.shared.windows.first else{
            return
        }
        let navVC = NavigationController(rootViewController: vc)
        window.rootViewController = navVC
    }
}

// MARK: - Routing and datapassing for one nav action
extension LanguagePageRouter {

}
