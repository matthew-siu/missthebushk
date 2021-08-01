//
//  StopListPageInteractor.swift
//  missthebus
//
//  Created by Matthew Siu on 20/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import PromiseKit

// MARK: - Requests from view
protocol StopListPageBusinessLogic
{
    func loadAllStopsFromRoute()
//    func requestOneStopETA(stopId: String, route: String, serviceType: String)
    func startETATimer(stopId: String, route: String, serviceType: String)
    func dismissETATimer()
}

// MARK: - Datas retain in interactor defines here
protocol StopListPageDataStore
{
    
}

// MARK: - Interactor Body
class StopListPageInteractor: StopListPageBusinessLogic, StopListPageDataStore
{
    // VIP Properties
    var presenter: StopListPagePresentationLogic?
    var worker: StopListPageWorker?
    
    // State
    var route: KmbRoute
    var reminders: [StopReminder]?
    var etaTimer: Timer?
    var selectedStopId: String?
    
    // Init
    init(request: StopListPageBuilder.BuildRequest) {
        print("route: \(request.route.route)")
        self.selectedStopId = request.stop?.stopId
        self.route = request.route
    }
}

// MARK: - Business
extension StopListPageInteractor {
    
    func loadAllStopsFromRoute(){
        // load all stops
        var stopList = [KmbStop]()
        guard let allStopList = KmbManager.getAllStops() else {return}
        for stop in route.stopList{
            if let targetStop = allStopList.first(where: {$0.stopId == stop.stopId}){
                stopList.append(targetStop)
            }
        }
        print("stopList: \(stopList.count)")
        
        // load all related reminder()
        self.loadAllStopRemindersOfRoute()
        
        self.presenter?.displayInitialState(route: route, stopList: stopList, reminders: self.reminders ?? [], selectedStopId: self.selectedStopId)
        
        if let selectedStopId = self.selectedStopId {
            self.startETATimer(stopId: selectedStopId, route: self.route.route, serviceType: self.route.serviceType)
        }
    }
    
    private func loadAllStopRemindersOfRoute(){
        self.reminders = StopReminderManager.getRemindersFromRoute(route: self.route.route, bound: self.route.bound, serviceType: self.route.serviceType)
        print("reminders: \(String(describing: self.reminders?.count))")
    }
    
    func startETATimer(stopId: String, route: String, serviceType: String){
        self.dismissETATimer()
        let query = KmbETAQuery(stopId: stopId, route: route, serviceType: serviceType)
        self.requestOneStopETA(query: query)
        self.etaTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(requestETA), userInfo: query, repeats: true)
    }
    
    @objc
    func requestETA(_ timer: Timer)
    {
        guard let query = timer.userInfo as? KmbETAQuery else {
            return
        }
        self.requestOneStopETA(query: query)
    }
    
    func requestOneStopETA(query: KmbETAQuery){
        DispatchQueue.main.async {
            
            KmbManager.requestOneStopETA(query: query)
                .done{response in
                    if let resp = response?.data{
                        self.presenter?.displayETA(data: resp)
                    }else{
                        self.presenter?.displayETA(data: nil)
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
