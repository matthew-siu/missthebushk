//
//  SplashScreenInteractor.swift
//  missthebus
//
//  Created by Matthew Siu on 30/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import PromiseKit

// MARK: - Requests from view
protocol SplashScreenBusinessLogic
{
    func requestAllKmbStaticInfo() -> Promise<Bool>
}

// MARK: - Datas retain in interactor defines here
protocol SplashScreenDataStore
{
    
}

// MARK: - Interactor Body
class SplashScreenInteractor: SplashScreenBusinessLogic, SplashScreenDataStore
{
    // VIP Properties
    var presenter: SplashScreenPresentationLogic?
    var worker: SplashScreenWorker?
    
    // State
    var allBusInfo = BusInfo()
    
    var kmbInfo = BusInfo()
    var ctbInfo = BusInfo()
    var nwfbInfo = BusInfo()
    var nlbInfo = BusInfo()
    
    struct BusInfo{
        var routes = [Route]()
        var stops = [Stop]()
    }
    
    enum Progress: Float {
        case KmbRoute = 0
        case KmbStop = 0.1
        case CtbRoute = 0.2
        case CtbStop1 = 0.3
        case CtbStop2 = 0.4
        case NwfbRoute = 0.5
        case NwfbStop1 = 0.6
        case NwfbStop2 = 0.7
        case NlbRoute = 0.8
        case NlbStop = 0.9
        case Complete = 1
    }
    
    // Init
    init(request: SplashScreenBuilder.BuildRequest) {
        
    }
}

// MARK: - Business
extension SplashScreenInteractor {
    
    func requestAllKmbStaticInfo() -> Promise<Bool>{
        return Promise { promise in
//            if (!self.needUpdate()) {
//                self.updateProgress("loading_check_update".localized(), to: 1)
//                promise.fulfill(false)
//                return
//            }
            DispatchQueue.main.async {
                NSLog("[API] Get all routes")
                self.initKmb()
                    .then{_ in self.initCtbNwfb()}
                    .then{_ in self.initNlb()}
                    .done{_ in
                        self.updateProgress("loading_completed".localized(), to: Progress.Complete.rawValue)
                        self.saveRoutes()
                        self.saveStops()
                        self.saveLastUpdate()
                        promise.fulfill(true)
                    }
                    .catch{err in
                        print("error: \(err.localizedDescription)")
                        promise.reject(err)
                    }
            }
        }
    }
    
    func deserializeRoutes(_ response: APIResponse?){
        if let response = response as? KmbRouteResponse{
            if let resp = response.data{
                let routes = resp.map{ Route(data: $0)}
                NSLog("[API] KMB routes = \(routes.count)")
                self.kmbInfo.routes = routes
            }
        }else if let response = response as? CtbNwfbRouteResponse{
            if let resp = response.data{
                var routes = [Route]()
                for route in resp{
                    routes.append(Route(data: route, bound: "I"))
                    routes.append(Route(data: route, bound: "O"))
                }
                if (routes.count > 0){
                    if (routes[0].company == .CTB){
                        NSLog("[API] CTB routes = \(routes.count)")
                        self.ctbInfo.routes = routes
                    }else if (routes[0].company == .NWFB){
                        NSLog("[API] NWFB routes = \(routes.count)")
                        self.nwfbInfo.routes = routes
                    }
                }
            }
        }else if let response = response as? NlbRouteResponse{
            if let resp = response.routes{
                let routes = resp.map{ Route(data: $0)}
                NSLog("[API] NLB routes = \(routes.count)")
                self.nlbInfo.routes = routes
            }
        }
    }
    
    func deserializeStops(_ response: APIResponse?){
        if let response = response as? KmbStopResponse{
            if let resp = response.data{
                let stops = resp.map{ Stop(data: $0)}
                NSLog("[API] KMB stops = \(stops.count)")
                self.kmbInfo.stops = stops
            }
        }
    }
    
    func saveRoutes(){
        self.allBusInfo.routes = []
        self.allBusInfo.routes += self.kmbInfo.routes
        self.allBusInfo.routes += self.ctbInfo.routes
        self.allBusInfo.routes += self.nwfbInfo.routes
        self.allBusInfo.routes += self.nlbInfo.routes
        KmbManager.saveAllRoutes(self.allBusInfo.routes)
    }
    
    func saveStops(){
        self.allBusInfo.stops = []
        self.allBusInfo.stops += self.kmbInfo.stops
        self.allBusInfo.stops += self.ctbInfo.stops
        self.allBusInfo.stops += self.nwfbInfo.stops
        self.allBusInfo.stops += self.nlbInfo.stops
        KmbManager.saveAllStops(self.allBusInfo.stops)
    }
    
    func needUpdate() -> Bool{
        return Storage.getString(Configs.Storage.KEY_LAST_UPDATE) != Utils.getCurrentTime(pattern: "yyyy-MM-dd")
    }
    
    func saveLastUpdate(){
        let now = Utils.getCurrentTime(pattern: "yyyy-MM-dd")
        Storage.save(Configs.Storage.KEY_LAST_UPDATE, now)
    }
    
}

// MARK: KmbAPI

extension SplashScreenInteractor{
    /* initKmb:
        1. get all routes
        2. get all stops
        3. get all route-stop
     */
    func initKmb() -> Promise<Any>{
        return Promise{ promise in
            self.updateProgress("loading_kmb".localized(), to: Progress.KmbRoute.rawValue)
            KmbManager.requestAllKmbRoutes()
                .done { data in self.deserializeRoutes(data) }
                .done { _ in self.updateProgress(to: Progress.KmbStop.rawValue)}
                .then{ _ in KmbManager.requestAllKmbStops() }
                .done{ data in self.saveKmbStops(data) }
                .then{ _ in KmbManager.requestAllKmbRouteStops() }
                .done{ data in self.saveKmbRouteStops(data) }
                .done { _ in
                    NSLog("[API] init KMB completed")
                    promise.fulfill(true)
                }
                .catch { err in promise.reject(err) }
        }
    }
    
    func saveKmbStops(_ response: KmbStopResponse?){
        if let resp = response?.data{
            self.kmbInfo.stops = resp.map{ Stop(data: $0)}
        }
    }
    
    func saveKmbRouteStops(_ response: KmbRouteStopResponse?){
        
        if let resp = response?.data{
            let routeStops = resp.map {RouteStop(data: $0)}
            for routeStop in routeStops{
                self.kmbInfo.routes.first(where: {
                    $0.route == routeStop.route &&
                    $0.bound == routeStop.bound &&
                    $0.serviceType == routeStop.serviceType
                })?.appendStopList(routeStop)
            }
        }
    }
    
    func updateProgress(_ msg: String? = nil, to percentage: Float){
        if let msg = msg {
            self.presenter?.displayLoadingMsg(msg: msg)
        }
        self.presenter?.updateProgressBar(to: percentage)
    }
}

// MARK: CTB + NWFB API

extension SplashScreenInteractor{
    /* init CTB & NWFB:
        1. get all routes
        2. get all route-stop
        3. get stop by route-stop id
     */
    func initCtbNwfb() -> Promise<Any>{
        return Promise{ promise in
            self.updateProgress("loading_ctb".localized(), to: Progress.CtbRoute.rawValue)
            KmbManager.requestAllCtbRoutes()
                .done { data in self.deserializeRoutes(data) }
                .done { _ in self.updateProgress(to: Progress.CtbStop1.rawValue)}
                .then{ _ in self.requestAllRouteStops(company: .CTB) }
                .done { _ in self.updateProgress(to: Progress.CtbStop2.rawValue)}
                .then{ _ in self.requestAllStops(company: .CTB) }
                .done{ _ in self.updateProgress("loading_nwfb".localized(), to: Progress.NwfbRoute.rawValue)}
                .then{ _ in KmbManager.requestAllNwfbRoutes() }
                .done { data in self.deserializeRoutes(data) }
                .done { _ in self.updateProgress(to: Progress.NwfbStop1.rawValue)}
                .then{ _ in self.requestAllRouteStops(company: .NWFB) }
                .done { _ in self.updateProgress(to: Progress.NwfbStop2.rawValue)}
                .then{ _ in self.requestAllStops(company: .NWFB) }
                .done { _ in
                    NSLog("[API] init CTB+NWFB completed")
                    promise.fulfill(true)
                }
                .catch { err in promise.reject(err) }
        }
    }
    
    // 1. get all directions for each route
    // 2. get all routes for each directions
    func requestAllRouteStops(company: BusCompany) -> Promise<Any>{
        NSLog("[API] requestAllRouteStops: \(company.rawValue)")
        return Promise { promise in
            let busInfo = (company == .CTB) ? self.ctbInfo : self.nwfbInfo
            var routeRequestList = [Promise<CtbNwfbRouteStopResponse?>]()
            for route in busInfo.routes{
                routeRequestList.append(KmbManager.requestAllCtbNwfbRouteStops(busCompany: company, routeNum: route.route, bound: route.bound))
            }
            when(fulfilled: routeRequestList)
                .done{routeResponses in
                    for (index, routeResponse) in routeResponses.enumerated(){
                        if let routeStopResponse = routeResponse, let data = routeStopResponse.data{
                            if (data.count == 0){
                                let route = busInfo.routes[index]
//                                print("[API] \(index) : route \(route.route) [\(route.bound)] should remove")
                                if (company == .CTB){
                                    self.ctbInfo.routes.removeAll(where: {$0.route == route.route && $0.company == route.company && $0.bound == route.bound})
                                }else if (company == .NWFB){
                                    self.nwfbInfo.routes.removeAll(where: {$0.route == route.route && $0.company == route.company && $0.bound == route.bound})
                                }
                            }else{
                                for routeStop in data{
                                    let routeStop = RouteStop(data: routeStop)
                                    if (company == .CTB){
                                        self.ctbInfo.routes.first(where: {$0.route == routeStop.route && $0.company == company && $0.bound == routeStop.bound})?.appendStopList(routeStop)
                                    }else if (company == .NWFB){
                                        self.nwfbInfo.routes.first(where: {$0.route == routeStop.route && $0.company == company && $0.bound == routeStop.bound})?.appendStopList(routeStop)
                                    }
                                }
                            }
                        }
                    }
                    promise.fulfill(true)
                }
                .catch{ error in promise.reject(error) }
        }
    }
    
    func requestAllStops(company: BusCompany) -> Promise<Any>{
        NSLog("[API] requestAllStops: \(company.rawValue)")
        return Promise { promise in
            let busInfo = (company == .CTB) ? self.ctbInfo : self.nwfbInfo
            var stopRequestList = [Promise<CtbNwfbStopResponse?>]()
            var stopIdList = [String]()
            for route in busInfo.routes{
                for stop in route.stopList{
                    if !stopIdList.contains(stop.stopId){
                        stopIdList.append(stop.stopId)
                    }
                }
            }
            for stopId in stopIdList{
                stopRequestList.append(KmbManager.requestCtbNwfbStop(stopId: stopId))
            }
            when(fulfilled: stopRequestList)
                .done{stopResponses in
                    for (stopResponse) in stopResponses{
                        if let data = stopResponse?.data{
                            let stop = Stop(data: data)
                            if (company == .CTB){
                                self.ctbInfo.stops.append(stop)
                            }else if (company == .NWFB){
                                self.nwfbInfo.stops.append(stop)
                            }
                        }
                    }
                    promise.fulfill(true)
                }
                .catch{error in promise.reject(error)}
        }
    }
}

// MARK: NLB API

extension SplashScreenInteractor{
    /* init CTB & NWFB:
        1. get all routes
        2. get all route-stop
        3. conert to stop list
     */
    func initNlb() -> Promise<Any>{
        NSLog("[API] init NLB")
        return Promise{ promise in
            self.updateProgress("loading_nlb".localized(), to: Progress.NlbRoute.rawValue)
            KmbManager.requestAllNlbRoutes()
                .done{data in self.deserializeRoutes(data)}
                .done { _ in self.updateProgress(to: Progress.NlbStop.rawValue)}
                .then{_ in self.requestAllNlbRouteStops() }
                .done{_ in
                    NSLog("[API] init NLB completed")
                    promise.fulfill(true)
                    
                }
                .catch{err in promise.reject(err)}
        }
    }
    
    func requestAllNlbRouteStops() -> Promise<Bool>{
        return Promise{ promise in
            
            var stopRequestList = [Promise<NlbRouteStopResponse?>]()
            let routeIdList: [String] = self.nlbInfo.routes.map{$0.routeId}
            for routeId in routeIdList{
                stopRequestList.append(KmbManager.requestAllNlbRouteStops(routeId: routeId))
            }
            when(fulfilled: stopRequestList)
                .done{data in
                    for (index, route) in data.enumerated(){
                        if let route = route, let stops = route.stops{
                            for (seq, routeStopData) in stops.enumerated(){
                                let routeStop = RouteStop(data: routeStopData, route: self.nlbInfo.routes[index].route, routeId: self.nlbInfo.routes[index].routeId, seq: seq + 1)
                                self.nlbInfo.routes[index].appendStopList(routeStop)
                                if !self.nlbInfo.stops.contains(where: {$0.stopId == routeStop.stopId}){
                                    self.nlbInfo.stops.append(Stop(data: routeStopData))
                                }
                            }
                        }
                    }
                    NSLog("[API] NLB stops = \(self.nlbInfo.stops.count)")
                    promise.fulfill(true)
                }
                .catch{err in
                    print("error: \(err.localizedDescription)")
                    promise.reject(err)
                }
            
        }
    }
}
