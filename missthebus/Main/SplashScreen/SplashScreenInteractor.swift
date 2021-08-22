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
////                DispatchQueue.main.async {
////                    self.readNlbRoutes()
////                        .done{_ in promise.fulfill(true)}
////                        .catch{err in promise.reject(err)}
////                }
//            }
            DispatchQueue.main.async {
                NlbManager.requestAllRoutes()
                    .done{data in self.saveRoutes(data)}
                    .catch{err in
                        print("error: \(err.localizedDescription)")
                        promise.reject(err)
                    }
//                KmbManager.requestAllRoutes()
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
    
    func saveRoutes(_ response: KmbRouteResponse?){
        if let resp = response?.data{
            let routes = resp.map{ Route(data: $0)}
            KmbManager.saveAllRoutes(routes)
        }
    }
    
    func saveRoutes(_ response: NlbRouteResponse?){
        if let resp = response?.routes{
            let _ = resp.map{ Route(data: $0)}
//            KmbManager.saveAllRoutes(routes)
        }
    }
    
    func saveStops(_ response: KmbStopResponse?){
        
        
        if let resp = response?.data{
            let stops = resp.map{ KmbStop(data: $0)}
            KmbManager.saveAllStops(stops)
        }
    }
    
    func insertRouteStopsIntoRoutes(_ response: KmbRouteStopResponse?){
        
        guard let routes = KmbManager.getAllRoutes() else{
            print("no routes")
            return
        }
        
        if let resp = response?.data{
            
            let routeStops = resp.map {KmbRouteStop(data: $0)}
            
            for routeStop in routeStops{
                routes.first(where: {
                    $0.route == routeStop.route &&
                    $0.bound == routeStop.bound &&
                    $0.serviceType == routeStop.serviceType
                })?.appendStopList(routeStop)
            }
            KmbManager.saveAllRoutes(routes)
            
            for i in 0..<5{
                routes[i].printSelf()
            }
        }
    }
    
    func needUpdate() -> Bool{
        return Storage.getString(Configs.Storage.KEY_LAST_UPDATE) != Utils.getCurrentTime(pattern: "yyyy-MM-dd")
    }
    
    func saveLastUpdate(){
        let now = Utils.getCurrentTime(pattern: "yyyy-MM-dd")
        Storage.save(Configs.Storage.KEY_LAST_UPDATE, now)
    }
    
}

extension SplashScreenInteractor{
    func readNlbRoutes() -> Promise<Bool>{
        return Promise{ promise in
            DispatchQueue.main.async {
                NlbManager.requestAllRoutes()
                    .done{data in
                        promise.fulfill(true)
                    }
                    .catch{err in
                        print("error: \(err.localizedDescription)")
                        promise.reject(err)
                    }
            }
        }
    }
}
