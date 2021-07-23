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
    func routeToStopListPage(route: KmbRoute)
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

    func routeToStopListPage(route: KmbRoute){
        let request = StopListPageBuilder.BuildRequest(route: route)
        let vc = StopListPageBuilder.createScene(request: request)
        
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
