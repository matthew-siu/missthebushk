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
    func displayInitialState(type: SearchPage.RequestType)
    func presentTableView(routes: [Route])
}

// MARK: - Presenter main body
class SearchPagePresenter: SearchPagePresentationLogic
{
    
    weak var viewController: SearchPageDisplayLogic?
    
}

// MARK: - Presentation receiver
extension SearchPagePresenter {
    
    func displayInitialState(type: SearchPage.RequestType) {
        self.viewController?.displayInitialState(type: type)
    }
    
    func presentTableView(routes: [Route]){
        var routes: [SearchPage.RouteItem] = routes.map{SearchPage.RouteItem(routeNum: $0.route, bound: $0.bound, serviceType: $0.serviceType, company: $0.company, destStop: $0.destStop, origStop: $0.originStop)}
        routes = routes.sorted{
            let num1 = $0.routeNum.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
            let num2 = $1.routeNum.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
            if (num1 < num2){
                return true
            }else{
                let str1 = $0.routeNum.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789."))
                let str2 = $1.routeNum.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789."))
                return str1 < str2
            }
        }
        self.viewController?.presentTableView(viewModel: SearchPage.DisplayItem.ViewModel(routeList: routes))
        
    }
}
