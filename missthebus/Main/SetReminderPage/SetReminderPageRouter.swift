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
    func routeToStopListPage(index: Int)
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
        let request = SearchPageBuilder.BuildRequest(getRouteStopRequest: SearchPage.ServiceRequest.GetRouteStop())
        let vc = SearchPageBuilder.createScene(request: request)
        
        let navController = NavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        window?.rootViewController?.present(navController, animated: true, completion: { () in
            NSLog("search")
        })
    }
    
    
    func routeToStopListPage(index: Int) {
        if let reminderRoute = self.dataStore?.getRouteStopsRequestQuery(index: index), let route = reminderRoute.getRoute(){
            
//            let request = StopListPageBuilder.BuildRequest(route: routeObj, stop: nil, type: .GetRouteStopService, stops: route.stopIndex)
            let request = StopListPageBuilder.BuildRequest(getRouteStopsRequest: StopListPage.Service.Request.GetRouteStops(route: route, stops: reminderRoute.stopIndex))
            let vc = StopListPageBuilder.createScene(request: request)
            
            let navController = NavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            window?.rootViewController?.present(navController, animated: true, completion: { () in
                NSLog("search")
            })
        }
        
    }
    
}
