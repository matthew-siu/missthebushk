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
    func requestAllKmbStaticInfo()
}

// MARK: - Datas retain in interactor defines here
protocol MainPageDataStore
{
    
}

// MARK: - Interactor Body
class MainPageInteractor: MainPageBusinessLogic, MainPageDataStore
{
    // VIP Properties
    var presenter: MainPagePresentationLogic?
    var worker: MainPageWorker?
    
    
    func requestAllKmbStaticInfo(){
        if (!self.needUpdate()) { return }
        DispatchQueue.main.async {
            SVProgressHUD.show()
            KmbManager.requestAllRoutes()
                .done{data in self.saveRoutes(data)}
                .then{_ in KmbManager.requestAllStops()}
                .done{data in self.saveStops(data)}
                .then{_ in KmbManager.requestAllRouteStops()}
                .done{data in
                    SVProgressHUD.dismiss()
                    self.insertRouteStopsIntoRoutes(data)
                    self.saveLastUpdate()
                }
                .catch{err in
                    SVProgressHUD.dismiss()
                    print("error: \(err.localizedDescription)")
                }
        }
    }
}

// MARK: - Business
extension MainPageInteractor {
    func saveRoutes(_ response: KmbRouteResponse?){
        if let resp = response?.data{
            let routes = resp.map{ KmbRoute(data: $0)}
            KmbManager.saveAllRoutes(routes)
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
