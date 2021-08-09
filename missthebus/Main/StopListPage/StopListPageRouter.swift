//
//  StopListPageRouter.swift
//  missthebus
//
//  Created by Matthew Siu on 20/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - The main interface to be called by others
protocol StopListPageRoutingLogic
{
    func routeToSetReminderPage(mode: SetReminderPage.Mode, route: KmbRoute, stop: KmbStop)
    
    func responseGetRouteStopService()
}

// MARK: - The possible elements that can be
protocol StopListPageDataPassing
{
    var dataStore: StopListPageDataStore? { get }
}

// MARK: - Main router body
class StopListPageRouter: NSObject, StopListPageRoutingLogic, StopListPageDataPassing
{
    weak var viewController: StopListPageViewController?
    var dataStore: StopListPageDataStore?
}

// MARK: - Routing and datapassing for one nav action
extension StopListPageRouter {
    func routeToSetReminderPage(mode: SetReminderPage.Mode, route: KmbRoute, stop: KmbStop){
        let request = SetReminderPageBuilder.BuildRequest(route: route, stop: stop, mode: mode, reminder: nil)
        let vc = SetReminderPageBuilder.createScene(request: request)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func responseGetRouteStopService(){
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if let rootVC = window?.rootViewController as? NavigationController {
            for vc in rootVC.viewControllers{
                if let vc = vc as? SetReminderPageViewController{
                    vc.selectedStop = KmbRouteStop(route: "123", stopId: "XSC", bound: "I", serviceType: "1", seq: "3")
                }
            }
        }
        self.viewController?.dismiss(animated: true, completion: nil)
    }
}
