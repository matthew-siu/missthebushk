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
    func routeToSettingPage()
    func routeToStopListPage(item: MainPage.BookmarkItem)
    func routeToCreateReminderPage()
    func routeToUpdateReminderPage(index: Int)
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
    
    
    func routeToStopListPage(item: MainPage.BookmarkItem){
        if let reminder = dataStore?.getStopBookmark(route: item.routeMetadata, stopId: item.stopId), let route = reminder.route, let stop = reminder.stop{
            
            let request = StopListPageBuilder.BuildRequest(normalRequest: StopListPage.Service.Request.Normal(route: route, stop: stop))
            let vc = StopListPageBuilder.createScene(request: request)

            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func routeToSearchPage() {
        let request = SearchPageBuilder.BuildRequest(normalRequest: SearchPage.ServiceRequest.Normal())
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
    
    func routeToSettingPage(){
        let request = SettingPageBuilder.BuildRequest()
        let vc = SettingPageBuilder.createScene(request: request)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToCreateReminderPage(){
        let request = SetReminderPageBuilder.BuildRequest(mode: .CREATE, reminder: nil)
        let vc = SetReminderPageBuilder.createScene(request: request)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToUpdateReminderPage(index: Int){
        let request = SetReminderPageBuilder.BuildRequest(mode: .UPDATE, reminder: self.dataStore?.getStopReminder(index: index))
        let vc = SetReminderPageBuilder.createScene(request: request)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
