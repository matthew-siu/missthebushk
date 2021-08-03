//
//  MainPageInteractor.swift
//  missthebus
//
//  Created by Matthew Siu on 6/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

// MARK: - Requests from view
protocol MainPageBusinessLogic
{
    func loadAllStopRemindersOfRoute()
}

// MARK: - Datas retain in interactor defines here
protocol MainPageDataStore
{
    func getStopReminder(stopId: String) -> StopReminder?
}

// MARK: - Interactor Body
class MainPageInteractor: MainPageBusinessLogic, MainPageDataStore
{
    // VIP Properties
    var presenter: MainPagePresentationLogic?
    var worker: MainPageWorker?
    
    // State
    var reminders: [StopReminder]?
    var etaTimer: Timer?
    
    init(request: MainPageBuilder.BuildRequest) {
        
    }
}
// MARK: - Business
extension MainPageInteractor {
    
    func getStopReminder(stopId: String) -> StopReminder?{
        return self.reminders?.first(where: {$0.stopId == stopId})
    }
    
    func loadAllStopRemindersOfRoute(){
        if let reminders = StopReminderManager.getStopReminders(){
            self.reminders = reminders
            print("loadAllStopRemindersOfRoute \(reminders.count)")
            self.startETATimer()
            self.presenter?.displayBookmarks(reminders: reminders)
        }else{
            print("loadAllStopRemindersOfRoute nil")
        }
    }
}

// MARK: - Logic
extension MainPageInteractor {
    func startETATimer(){
        self.dismissETATimer()
        
        self.requestETA(nil)
        self.etaTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(requestETA), userInfo: nil, repeats: true)
    }
    
    @objc
    func requestETA(_ timer: Timer?)
    {
        if let reminders = self.reminders{
            for reminder in reminders{
                let query = KmbETAQuery(stopId: reminder.stopId, route: reminder.routeNum, serviceType: reminder.serviceType)
                self.requestOneStopETA(query: query, bound: reminder.bound)
            }
        }
    }
    
    func requestOneStopETA(query: KmbETAQuery, bound: String){
        DispatchQueue.main.async {
            
            KmbManager.requestOneStopETA(query: query)
                .done{response in
                    if let resp = response?.data{
                        self.presenter?.updateETAs(query: query, bound: bound, data: resp)
                    }
                }
                .catch{err in
                    print("fail")
                }
        }
    }
    
    func dismissETATimer(){
        print("dismiss ETA time")
        self.etaTimer?.invalidate()
        self.etaTimer = nil
    }
}
