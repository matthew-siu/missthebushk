//
//  SettingPageRouter.swift
//  missthebus
//
//  Created by Matthew Siu on 20/8/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - The main interface to be called by others
protocol SettingPageRoutingLogic
{
    func routeToLanguagePage()
    func routeToAboutUsPage()
    func restartApp()
}

// MARK: - The possible elements that can be
protocol SettingPageDataPassing
{
    var dataStore: SettingPageDataStore? { get }
}

// MARK: - Main router body
class SettingPageRouter: NSObject, SettingPageRoutingLogic, SettingPageDataPassing
{
    weak var viewController: SettingPageViewController?
    var dataStore: SettingPageDataStore?
    
    
    func routeToLanguagePage(){
        let request = LanguagePageBuilder.BuildRequest()
        let vc = LanguagePageBuilder.createScene(request: request)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToAboutUsPage(){
        let request = AboutUsPageBuilder.BuildRequest()
        let vc = AboutUsPageBuilder.createScene(request: request)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
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
extension SettingPageRouter {

}
