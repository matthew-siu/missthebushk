//
//  AppDelegate.swift
//  missthebus
//
//  Created by Matthew Siu on 6/7/2021.
//

import UIKit
import GoogleMobileAds
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let request = SplashScreenBuilder.BuildRequest()
        let splashScreenVC = SplashScreenBuilder.createScene(request: request)
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GMSServices.provideAPIKey(Configs.GoogleMap.apiKey)
        
        UIApplication.shared.windows.first?.rootViewController = splashScreenVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
        return true
        
        
    }
    

}

