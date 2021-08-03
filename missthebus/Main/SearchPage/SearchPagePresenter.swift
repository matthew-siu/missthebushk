//
//  SearchPagePresenter.swift
//  missthebus
//
//  Created by Matthew Siu on 7/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Presentation logic goes here
protocol SearchPagePresentationLogic
{
    func presentTableView(routes: [KmbRoute])
}

// MARK: - Presenter main body
class SearchPagePresenter: SearchPagePresentationLogic
{
    weak var viewController: SearchPageDisplayLogic?
    
}

// MARK: - Presentation receiver
extension SearchPagePresenter {
    func presentTableView(routes: [KmbRoute]){
        let routes: [SearchPage.RouteItem] = routes.map{SearchPage.RouteItem(routeNum: $0.route, bound: $0.bound, serviceType: $0.serviceType, company: $0.company, destStop: $0.destStop, origStop: $0.originStop)}
        self.viewController?.presentTableView(viewModel: SearchPage.DisplayItem.ViewModel(routeList: routes))
        
    }
}
