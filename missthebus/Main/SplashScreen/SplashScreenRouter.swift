//
//  SplashScreenRouter.swift
//  missthebus
//
//  Created by Matthew Siu on 30/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - The main interface to be called by others
protocol SplashScreenRoutingLogic
{
    func routeToMainPage()
}

// MARK: - The possible elements that can be
protocol SplashScreenDataPassing
{
    var dataStore: SplashScreenDataStore? { get }
}

// MARK: - Main router body
class SplashScreenRouter: NSObject, SplashScreenRoutingLogic, SplashScreenDataPassing
{
    weak var viewController: SplashScreenViewController?
    var dataStore: SplashScreenDataStore?
}

// MARK: - Routing and datapassing for one nav action
extension SplashScreenRouter {
    
    func routeToMainPage() {
        let request = MainPageBuilder.BuildRequest()
        let vc = MainPageBuilder.createScene(request: request)
        
        guard let window = UIApplication.shared.windows.first else{
            return
        }
        let navVC = NavigationController(rootViewController: vc)
        window.rootViewController = navVC
        
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
        { completed in
            // maybe do something on completion here
        })
        
    }
}
