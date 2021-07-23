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
    func requestAllKmbStaticInfo(stopId: String, route: String, serviceType: String)
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
    
    // Init
    init(request: StopListPageBuilder.BuildRequest) {
        print("route: \(request.route.route)")
        self.route = request.route
    }
}

// MARK: - Business
extension StopListPageInteractor {
    func loadAllStopsFromRoute(){
        var stopList = [KmbStop]()
        guard let allStopList = KmbManager.getAllStops() else {return}
        for stop in route.stopList{
            if let targetStop = allStopList.first(where: {$0.stopId == stop.stopId}){
                stopList.append(targetStop)
            }
        }
        print("stopList: \(stopList.count)")
        
        self.presenter?.displayInitialState(route: route, stopList: stopList)
    }
    
    
    func requestAllKmbStaticInfo(stopId: String, route: String, serviceType: String){
        DispatchQueue.main.async {
            KmbManager.requestOneStopETA(stopId: stopId, route: route, serviceType: serviceType)
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
