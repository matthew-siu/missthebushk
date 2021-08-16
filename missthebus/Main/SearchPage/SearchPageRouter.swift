//
//  SearchPageRouter.swift
//  missthebus
//
//  Created by Matthew Siu on 7/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - The main interface to be called by others
protocol SearchPageRoutingLogic
{
    func routeToStopListPage(route: SearchPage.RouteItem)
}

// MARK: - The possible elements that can be
protocol SearchPageDataPassing
{
    var dataStore: SearchPageDataStore? { get }
}

// MARK: - Main router body
class SearchPageRouter: NSObject, SearchPageRoutingLogic, SearchPageDataPassing
{
    weak var viewController: SearchPageViewController?
    var dataStore: SearchPageDataStore?
}

// MARK: - Routing and datapassing for one nav action
extension SearchPageRouter {

    func routeToStopListPage(route: SearchPage.RouteItem){
        if let routeObj = self.dataStore?.getRoute(routeItem: route), let type = self.dataStore?.getType(){
            var request = StopListPageBuilder.BuildRequest()
            if (type == .NormalNavigation){
                request = StopListPageBuilder.BuildRequest(normalRequest: StopListPage.Service.Request.Normal(route: routeObj, stop: nil))
            }else if (type == .GetRouteStopService){
                request = StopListPageBuilder.BuildRequest( getRouteStopsRequest: StopListPage.Service.Request.GetRouteStops(route: routeObj, stops: []))
            }
            let vc = StopListPageBuilder.createScene(request: request)
            
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
