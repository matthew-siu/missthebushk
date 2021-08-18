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
    
    func responseGetRouteStopService(resp: StopListPage.Service.Response.GetRouteStops)
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
    
    func responseGetRouteStopService(resp: StopListPage.Service.Response.GetRouteStops){
        var sortedResp = resp // ascending order
        sortedResp.stops.sort()
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if let rootVC = window?.rootViewController as? NavigationController {
            for vc in rootVC.viewControllers{
                if let vc = vc as? SetReminderPageViewController{
                    vc.getRouteStopResponse = sortedResp
                }
            }
        }
        self.viewController?.dismiss(animated: true, completion: nil)
    }
}
