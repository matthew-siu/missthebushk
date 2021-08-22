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
    func displayRouteAndStopList()
    func getRouteStopResponse(resp: StopListPage.Service.Response.GetRouteStops)
    func removeRouteStop(at index: Int)
    func rearrangeReminder(at pos1: Int, to pos2: Int)
}

// MARK: - Datas retain in interactor defines here
protocol SetReminderPageDataStore
{
    func getRouteStopsRequestQuery(index: Int) -> StopReminder.StopReminderRoute
}

// MARK: - Interactor Body
class SetReminderPageInteractor: SetReminderPageBusinessLogic, SetReminderPageDataStore
{
    
    // VIP Properties
    var presenter: SetReminderPagePresentationLogic?
    var worker: SetReminderPageWorker?
    
    // State
    var route: Route?
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
            self.reminder.printDetails()
            StopReminderManager.addStopReminder(self.reminder)
        }else{
            print("update reminder \(self.reminder.id)")
            StopReminderManager.updateStopReminder(self.reminder)
        }
    }
    
    func getRouteStopResponse(resp: StopListPage.Service.Response.GetRouteStops) {
        if let route = (self.reminder.routes.first(where: {$0.routeNum == resp.route.route && $0.bound == resp.route.bound && $0.serviceType == resp.route.serviceType})){
            route.stopIndex = resp.stops
        }else{
            self.reminder.routes.append(StopReminder.StopReminderRoute(route: RouteMetadata(resp.route.route, resp.route.bound, resp.route.serviceType), stopIndex: resp.stops))
        }
        
        self.presenter?.updateRouteAndStop(self.reminder)
    }
    
    func displayRouteAndStopList(){
        self.presenter?.updateRouteAndStop(self.reminder)
    }
    
    func removeRouteStop(at index: Int){
        self.reminder.routes.remove(at: index)
    }
    
    func rearrangeReminder(at pos1: Int, to pos2: Int) {
        let mover = self.reminder.routes.remove(at: pos1)
        self.reminder.routes.insert(mover, at: pos2)
    }
    
}

// MARK: - DataStore
extension SetReminderPageInteractor{
    
    func getRouteStopsRequestQuery(index: Int) -> StopReminder.StopReminderRoute{
        return self.reminder.routes[index]
    }
}
