//
//  SetReminderPagePresenter.swift
//  missthebus
//
//  Created by Matthew Siu on 26/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Presentation logic goes here
protocol SetReminderPagePresentationLogic
{
    func displayInitialState(mode: SetReminderPage.Mode, reminder: StopReminder)
    
    func updateRouteAndStop(_ reminder: StopReminder)
}

// MARK: - Presenter main body
class SetReminderPagePresenter: SetReminderPagePresentationLogic
{
    
    weak var viewController: SetReminderPageDisplayLogic?
    
}

// MARK: - Presentation receiver
extension SetReminderPagePresenter {
    func displayInitialState(mode: SetReminderPage.Mode, reminder: StopReminder){
        
        
        if (mode == .UPDATE){
            
        }else{
            let viewModel = SetReminderPage.DisplayItem.ViewModel(mode: .CREATE)
            self.viewController?.displayCreateState(viewModel: viewModel)
        }
    }
    
    func updateRouteAndStop(_ reminder: StopReminder){
        var routes = [SetReminderPage.RouteAndStop]()
        for route in reminder.routes{
            var routeStops = [SetReminderPage.RouteStop]()
            for seq in route.stopIndex{
                let stop = SetReminderPage.RouteStop(seq: seq, label: route.getRoute()?.stopList[seq].stop?.name ?? "")
                routeStops.append(stop)
            }
            routes.append(SetReminderPage.RouteAndStop(routeNum: route.routeNum, bound: route.bound, service: route.serviceType, destStop: route.getRoute()?.destStop ?? "", targetStops: routeStops))
        }
        let viewModel = SetReminderPage.DisplayItem.RouteAndStopViewModel(routes: routes)
        self.viewController?.updateRouteAndStop(viewModel: viewModel)
    }
    
    
}
