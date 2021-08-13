//
//  SetReminderPageInteractor.swift
//  missthebus
//
//  Created by Matthew Siu on 26/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Requests from view
protocol SetReminderPageBusinessLogic
{
    func displayInitialState()
    func saveReminder(request: SetReminderPage.DisplayItem.Request)
    func getRouteStopResponse(resp: SetReminderPage.GetRouteStopResponse)
}

// MARK: - Datas retain in interactor defines here
protocol SetReminderPageDataStore
{
    func getRouteStopsRequestQuery(index: Int) -> StopReminder.Route
}

// MARK: - Interactor Body
class SetReminderPageInteractor: SetReminderPageBusinessLogic, SetReminderPageDataStore
{
    
    // VIP Properties
    var presenter: SetReminderPagePresentationLogic?
    var worker: SetReminderPageWorker?
    
    // State
    var route: KmbRoute?
    var stop: KmbStop?
    var mode: SetReminderPage.Mode
    var reminder: StopReminder
    
    // Init
    init(request: SetReminderPageBuilder.BuildRequest) {
        self.mode = request.mode
        if let reminder = request.reminder{
            self.reminder = reminder
        }else{
            self.reminder = StopReminder(time: Date())
        }
    }
    
    
}

// MARK: - Business
extension SetReminderPageInteractor {
    func displayInitialState(){
        self.presenter?.displayInitialState(mode: self.mode, reminder: self.reminder)
    }
    
    func saveReminder(request: SetReminderPage.DisplayItem.Request) {
        self.reminder.name = request.reminderName
        self.reminder.type = request.reminderType
        self.reminder.startTime = request.time
        self.reminder.period = request.period
        
        if (self.mode == .CREATE){
            print("add new reminder \(self.reminder.id)")
            StopReminderManager.addStopReminder(self.reminder)
        }else{
            print("update new reminder \(self.reminder.id)")
            StopReminderManager.updateStopReminder(self.reminder)
        }
    }
    
    func getRouteStopResponse(resp: SetReminderPage.GetRouteStopResponse) {
        self.reminder.routes.append(StopReminder.Route(routeNum: resp.routeNum, bound: resp.bound, serviceType: resp.serviceType, stopIndex: resp.stopSeqList))
        self.presenter?.updateRouteAndStop(self.reminder)
    }
    
    func getRouteStopsRequestQuery(index: Int) -> StopReminder.Route{
        return self.reminder.routes[index]
    }
}
