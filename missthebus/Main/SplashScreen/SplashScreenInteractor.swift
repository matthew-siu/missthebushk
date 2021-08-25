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
    
    // Init
    init(request: SplashScreenBuilder.BuildRequest) {
        
    }
}

// MARK: - Business
extension SplashScreenInteractor {
    
    func requestAllKmbStaticInfo() -> Promise<Bool>{
        return Promise { promise in
//            if (!self.needUpdate()) {
//                promise.fulfill(false)
//                return
//            }
            DispatchQueue.main.async {
                NSLog("[API] Get all routes")
                self.initKmb()
//                    .then{_ in self.initCtbNwfb()}
                    .then{_ in self.initNlb()}
                    .done{_ in
//                        self.insertRouteStopsIntoRoutes(data)
//                        self.saveLastUpdate()
                        promise.fulfill(true)
                    }
                    .catch{err in
                        print("error: \(err.localizedDescription)")
                        promise.reject(err)
                    }
//                KmbManager.requestKmbAllRoutes()
//                    .done{data in self.saveRoutes(data)}
//                    .then{_ in KmbManager.requestAllStops()}
//                    .done{data in self.saveStops(data)}
//                    .then{_ in KmbManager.requestAllRouteStops()}
//                    .done{data in
//                        self.insertRouteStopsIntoRoutes(data)
//                        self.saveLastUpdate()
//                        promise.fulfill(true)
//                    }
//                    .catch{err in
//                        print("error: \(err.localizedDescription)")
//                        promise.reject(err)
//                    }
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
            KmbManager.requestAllKmbRoutes()
                .done { data in self.deserializeRoutes(data) }
                .then{ _ in KmbManager.requestAllKmbStops() }
                .done{ data in self.saveKmbStops(data) }
                .then{ _ in KmbManager.requestAllKmbRouteStops() }
                .done { _ in
                    NSLog("[API] init KMB completed")
                    promise.fulfill(true)
                }
                .catch { err in promise.reject(err) }
        }
    }
    
    func saveKmbStops(_ response: KmbStopResponse?){
        if let resp = response?.data{
//            let stops = resp.map{ Stop(data: $0)}
            self.kmbInfo.stops = resp.map{ Stop(data: $0)}
//            KmbManager.saveAllStops(stops)
        }
    }
    
    func insertRouteStopsIntoRoutes(_ response: KmbRouteStopResponse?){
        
        guard let routes = KmbManager.getAllRoutes() else{
            print("no routes")
            return
        }

        if let resp = response?.data{
            let routeStops = resp.map {RouteStop(data: $0)}
            for routeStop in routeStops{
                routes.first(where: {
                    $0.route == routeStop.route &&
                    $0.bound == routeStop.bound &&
                    $0.serviceType == routeStop.serviceType
                })?.appendStopList(routeStop)
            }
//            KmbManager.saveAllRoutes(routes)
        }
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
            KmbManager.requestAllCtbRoutes()
                .done { data in self.deserializeRoutes(data) }
                .then{ _ in KmbManager.requestAllNwfbRoutes() }
                .done { data in self.deserializeRoutes(data) }
                .then{ _ in self.requestAllRouteStops(company: .CTB) }
                .then{ _ in self.requestAllRouteStops(company: .NWFB) }
                .then{ _ in self.requestAllStops(company: .CTB) }
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
            KmbManager.requestAllNlbRoutes()
                .done{data in self.deserializeRoutes(data)}
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
                    print("[API] data = \(data.count)")
                    for (index, route) in data.enumerated(){
                        if let route = route, let stops = route.routes{
                            print("[API] \(index). routeStopData = \(stops.count)")
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
