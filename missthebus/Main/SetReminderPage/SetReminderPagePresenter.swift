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
//            let viewModel = SetReminderPage.DisplayItem.ViewModel(mode: .UPDATE, reminderName: reminder.name, reminderType: reminder.type, routeNum: reminder.routeNum, busCompany: reminder.company, destStopName: route?.destStop, currentStopName: stop?.name, time: reminder.time, period: reminder.period)
//            self.viewController?.displayCreateState(viewModel: viewModel)
        }else{
            let viewModel = SetReminderPage.DisplayItem.ViewModel(mode: .CREATE)
            self.viewController?.displayCreateState(viewModel: viewModel)
        }
    }
    
    func updateRouteAndStop(_ reminder: StopReminder){
        var routes = [SetReminderPage.RouteAndStop]()
        for (index, route) in reminder.routes.enumerated(){
            var routeStops = [SetReminderPage.RouteStop]()
            for seq in route.stopIndex{
                let stop = SetReminderPage.RouteStop(seq: seq, label: route.getStop(index)?.name ?? "")
                routeStops.append(stop)
            }
            routes.append(SetReminderPage.RouteAndStop(routeNum: route.routeNum, bound: route.bound, service: route.serviceType, destStop: route.getRoute()?.destStop ?? "", targetStops: routeStops))
        }
        let viewModel = SetReminderPage.DisplayItem.RouteAndStopViewModel(routes: routes)
        self.viewController?.updateRouteAndStop(viewModel: viewModel)
    }
    
    
}
