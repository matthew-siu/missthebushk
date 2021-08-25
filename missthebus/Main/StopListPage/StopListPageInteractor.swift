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
    func startETATimer(stopId: String, route: String, serviceType: String)
    func dismissETATimer()
    func bookmark(stop: Stop, isMarked: Bool)
    func getRouteStopResponse() -> StopListPage.Service.Response.GetRouteStops?
    
}

// MARK: - Datas retain in interactor defines here
protocol StopListPageDataStore
{
    func getType() -> StopListPage.RequestType
}

// MARK: - Interactor Body
class StopListPageInteractor: StopListPageBusinessLogic, StopListPageDataStore
{
    // VIP Properties
    var presenter: StopListPagePresentationLogic?
    var worker: StopListPageWorker?
    
    // State
    var type: StopListPage.RequestType = .NormalNavigation
    
    var route: Route
    var bookmarks: [StopBookmark]?
    var etaTimer: Timer?
    
//    var selectedStopId: String?
//    var selectedStopSeqList: [Int]
    var normalResp: StopListPage.Service.Response.Normal?
    var getRouteStopsResp: StopListPage.Service.Response.GetRouteStops?
    
    // Init
    init(request: StopListPageBuilder.BuildRequest) {
        if let request = request.normalRequest{
            self.type = request.type
            self.normalResp = StopListPage.Service.Response.Normal(route: request.route, stop: request.stop)
            self.route = request.route
        }else if let request = request.getRouteStopsRequest{
            self.type = request.type
            self.getRouteStopsResp = StopListPage.Service.Response.GetRouteStops(route: request.route, stops: request.stops)
            self.route = request.route
        }else{
            self.route = request.normalRequest!.route
        }
    }
}

// MARK: - Business
extension StopListPageInteractor {
    
    func loadAllStopsFromRoute(){
        // load all stops
        var stopList = [Stop]()
        guard let allStopList = KmbManager.getAllStops() else {return}
        for stop in self.route.stopList{
            if let targetStop = allStopList.first(where: {$0.stopId == stop.stopId}){
                stopList.append(targetStop)
            }
        }
        print("stopList: \(stopList.count)")
        
        // load all related reminder()
        self.loadAllBookmarksOfRoute()
        
        if (self.type == .NormalNavigation){
            
            self.presenter?.displayInitialNormalState(route: self.route, stopList: stopList, bookmarks: self.bookmarks ?? [], selectedStopId: self.normalResp?.stop?.stopId)
            if let selectedStopId = self.normalResp?.stop?.stopId {
                self.startETATimer(stopId: selectedStopId, route: self.route.route, serviceType: self.route.serviceType)
            }
        }else if (self.type == .GetRouteStopService){
            self.presenter?.displayInitialGetRouteStopState(route: self.route, stopList: stopList, bookmarks: self.bookmarks ?? [], selectedStopSeq: self.getRouteStopsResp?.stops ?? [])
        }
    }
    
    func startETATimer(stopId: String, route: String, serviceType: String){
        self.dismissETATimer()
        let query = KmbETAQuery(stopId: stopId, route: route, serviceType: serviceType)
        self.requestOneStopETA(query: query)
        self.etaTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(requestETA), userInfo: query, repeats: true)
    }
    
    func dismissETATimer(){
        print("dismiss ETA time")
        self.etaTimer?.invalidate()
        self.etaTimer = nil
    }
    
    func bookmark(stop: Stop, isMarked: Bool){
        if (isMarked){
            let bookmark = StopBookmark(routeNum: self.route.route, bound: self.route.bound, serviceType: self.route.serviceType, company: self.route.company, stopId: stop.stopId)
            StopBookmarkManager.addStopBookmark(bookmark)
        }else{
            if let bookmark = StopBookmarkManager.getOneBookmarkFromRoute(stopId: stop.stopId, route: self.route.route, bound: self.route.bound, serviceType: self.route.serviceType){
                StopBookmarkManager.removeStopBookmark(bookmark.id)
            }
            
        }
    }
    
    
    func getRouteStopResponse() -> StopListPage.Service.Response.GetRouteStops?{
        if (self.type == .GetRouteStopService){
            return StopListPage.Service.Response.GetRouteStops(route: self.route, stops: self.getRouteStopsResp?.stops ?? [])
        }
        return nil
        
    }
    
    func getType() -> StopListPage.RequestType{
        return self.type
    }
}

// MARK:- Logic
extension StopListPageInteractor{
    
    private func loadAllBookmarksOfRoute(){
        self.bookmarks = StopBookmarkManager.getBookmarksFromRoute(route: self.route.route, bound: self.route.bound, serviceType: self.route.serviceType)
        print("reminders: \(String(describing: self.bookmarks?.count))")
    }
    
    @objc
    private func requestETA(_ timer: Timer)
    {
        guard let query = timer.userInfo as? KmbETAQuery else {
            return
        }
        self.requestOneStopETA(query: query)
    }
    
    private func requestOneStopETA(query: KmbETAQuery){
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
}
