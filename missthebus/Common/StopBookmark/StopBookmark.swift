//
//  StopBookmark.swift
//  missthebus
//
//  Created by Matthew Siu on 5/8/2021.
//

import Foundation

class StopBookmark: Codable{
    
    var id: String
    
    var company: BusCompany
    var stopId: String
    var routeNum: String
    var bound: String
    var serviceType: String
    
    init(routeNum: String, bound: String, serviceType: String, company: BusCompany, stopId: String){
        self.id = UUID().uuidString
        self.routeNum = routeNum
        self.bound = bound
        self.serviceType = serviceType
        self.company = company
        self.stopId = stopId
    }
    
    var currentStop: String?{
        return KmbManager.getStop(stopId: self.stopId)?.name
    }
    
    var destStop: String?{
        return KmbManager.getRoute(route: self.routeNum, bound: self.bound, serviceType: self.serviceType)?.destStop
    }
    
    var stop: Stop?{
        return KmbManager.getStop(stopId: self.stopId)
    }
    var route: Route?{
        return KmbManager.getRoute(route: self.routeNum, bound: self.bound, serviceType: self.serviceType)
    }
    var routeMetadata: RouteMetadata{
        return RouteMetadata(self.routeNum, self.bound, self.serviceType)
    }
    
}
