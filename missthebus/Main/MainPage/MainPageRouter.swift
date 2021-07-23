//
//  MainPageRouter.swift
//  missthebus
//
//  Created by Matthew Siu on 6/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - The main interface to be called by others
protocol MainPageRoutingLogic
{
    func routeToSearchPage()
}

// MARK: - The possible elements that can be
protocol MainPageDataPassing
{
    var dataStore: MainPageDataStore? { get }
}

// MARK: - Main router body
class MainPageRouter: NSObject, MainPageRoutingLogic, MainPageDataPassing
{
    weak var viewController: MainPageViewController?
    var dataStore: MainPageDataStore?
}

// MARK: - Routing and datapassing for one nav action
extension MainPageRouter {
    
    
    func routeToSearchPage() {
        let request = SearchPageBuilder.BuildRequest()
        let vc = SearchPageBuilder.createScene(request: request)
//        vc.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .push
        transition.subtype = .fromTop
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.viewController?.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.viewController?.navigationController?.pushViewController(vc, animated: false)
        
    }
}
