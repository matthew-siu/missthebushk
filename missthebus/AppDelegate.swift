//
//  AppDelegate.swift
//  missthebus
//
//  Created by Matthew Siu on 6/7/2021.
//

import UIKit
import GoogleMobileAds
import GoogleMaps
import WidgetKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let request = SplashScreenBuilder.BuildRequest()
        let splashScreenVC = SplashScreenBuilder.createScene(request: request)
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GMSServices.provideAPIKey(Configs.GoogleMap.apiKey)
        
        UIApplication.shared.windows.first?.rootViewController = splashScreenVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
        // allow pop notification when app is foreground
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        print("enter foreground (first)")
        self.reloadWidget()
        
        return true
        
        
    }
    
    
    // 在前景收到通知時所觸發的 function
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("在前景收到通知...")
        completionHandler([.badge, .sound, .alert])
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("enter foreground")
        self.reloadWidget()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("enter background")
    }
    
    private func reloadWidget(){
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        } else {
            // Fallback on earlier versions
        }
    }
}

