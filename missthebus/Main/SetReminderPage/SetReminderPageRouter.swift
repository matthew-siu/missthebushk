//
//  SetReminderPageRouter.swift
//  missthebus
//
//  Created by Matthew Siu on 26/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - The main interface to be called by others
protocol SetReminderPageRoutingLogic
{
    func routeToSearchPage()
}

// MARK: - The possible elements that can be
protocol SetReminderPageDataPassing
{
    var dataStore: SetReminderPageDataStore? { get }
}

// MARK: - Main router body
class SetReminderPageRouter: NSObject, SetReminderPageRoutingLogic, SetReminderPageDataPassing
{
    weak var viewController: SetReminderPageViewController?
    var dataStore: SetReminderPageDataStore?
}

// MARK: - Routing and datapassing for one nav action
extension SetReminderPageRouter {
    
    func routeToSearchPage() {
        let request = SearchPageBuilder.BuildRequest(type: .GetRouteStopService)
        let vc = SearchPageBuilder.createScene(request: request)
//        vc.modalPresentationStyle = .fullScreen
        
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = .push
//        transition.subtype = .fromTop
//        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        self.viewController?.navigationController?.view.layer.add(transition, forKey: kCATransition)
//        self.viewController?.navigationController?.pushViewController(vc, animated: false)
        
        
        let navController = NavigationController(rootViewController: vc)
//        navController.modalPresentationStyle = .formSheet
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        window?.rootViewController?.present(navController, animated: true, completion: { () in
            NSLog("search")
        })
    }
    
}
