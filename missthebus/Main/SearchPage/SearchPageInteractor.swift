//
//  SearchPageInteractor.swift
//  missthebus
//
//  Created by Matthew Siu on 7/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Requests from view
protocol SearchPageBusinessLogic
{
    
    func requestKmbRouteList()
}

// MARK: - Datas retain in interactor defines here
protocol SearchPageDataStore
{
    func getRoute(routeItem: SearchPage.RouteItem) -> KmbRoute?
}

// MARK: - Interactor Body
class SearchPageInteractor: SearchPageBusinessLogic, SearchPageDataStore
{
    
    // VIP Properties
    var presenter: SearchPagePresentationLogic?
    var worker: SearchPageWorker?
    
    // State
    var routes: [KmbRoute]?
    
    // Init
    init(request: SearchPageBuilder.BuildRequest) {
        
    }
    
    func requestKmbRouteList(){
        DispatchQueue.main.async {
            if let routes = KmbManager.getAllRoutes(){
                self.routes = routes
                self.presenter?.presentTableView(routes: routes)
            }else{
                SearchPageWorker.getAllRoutes { (response, error) in
                    if let resp = response?.data{
                        let routes = resp.map{KmbRoute(data: $0)}
                        self.routes = routes
                        self.presenter?.presentTableView(routes: routes)
                    }
                }
            }
        }
    }
    
    // SearchPageDataStore - for router
    func getRoute(routeItem: SearchPage.RouteItem) -> KmbRoute? {
        return self.routes?.first(where: {$0.route == routeItem.routeNum && $0.bound == routeItem.bound && $0.serviceType == routeItem.serviceType})
    }
}

// MARK: - Business
extension SearchPageInteractor {

}
