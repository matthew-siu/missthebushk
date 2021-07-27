//
//  AppDelegate.swift
//  missthebus
//
//  Created by Matthew Siu on 6/7/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        guard let rootVC = UIStoryboard.init(name: "MainPageViewController", bundle: nil).instantiateViewController(withIdentifier: "MainPageViewController") as? MainPageViewController else {
//            return true
//        }
        let request = SearchPageBuilder.BuildRequest()
        let rootVC = SearchPageBuilder.createScene(request: request)
        
        let navVC = NavigationController(rootViewController: rootVC)
        UIApplication.shared.windows.first?.rootViewController = navVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
        return true
        
        
    }

}

