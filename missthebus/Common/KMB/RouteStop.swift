//
//  KmbRouteStop.swift
//  missthebus
//
//  Created by Matthew Siu on 21/7/2021.
//

import Foundation

class RouteStop: Codable{
    let route: String
    let stopId: String
    let bound: String // O || I
    let serviceType: String
    let seq: String
    var routeId: String? = nil

    init(data: KmbRouteStopResponse.KmbRouteStopData){
        self.route = data.route ?? ""
        self.stopId = data.stop ?? ""
        self.bound = data.bound ?? ""
        self.serviceType = data.service_type ?? ""
        self.seq = data.seq ?? ""
    }
    
    init(data: CtbNwfbRouteStopResponse.CtbNwfbRouteStopData) {
        self.route = data.route ?? ""
        self.stopId = data.route ?? ""
        self.bound = data.dir ?? ""
        self.seq = String(data.seq ?? -1)
        self.serviceType = ""
    }
    
    init(data: NlbRouteStopResponse.NlbRouteStopData, route: String, routeId: String, seq: Int) {
        self.route = route
        self.routeId = routeId
        self.stopId = data.stopId ?? ""
        self.bound = ""
        self.seq = String(seq)
        self.serviceType = ""
    }
    
//    init(route: String, stopId: String, bound: String, serviceType: String, seq: String){
//        self.route = route
//        self.stopId = stopId
//        self.bound = bound
//        self.serviceType = serviceType
//        self.seq = seq
//    }
    
    var sequence: Int{
        return Int(self.seq) ?? -1
    }
    
    var stop: Stop?{
        return KmbManager.getStop(stopId: self.stopId)
    }
}
