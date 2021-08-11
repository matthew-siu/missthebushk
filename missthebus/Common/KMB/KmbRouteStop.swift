//
//  KmbRouteStop.swift
//  missthebus
//
//  Created by Matthew Siu on 21/7/2021.
//

import Foundation

class KmbRouteStop: Codable{
    let route: String
    let stopId: String
    let bound: String // O || I
    let serviceType: String
    let seq: String
    
    init(data: KmbRouteStopResponse.KmbRouteStopData){
        self.route = data.route ?? ""
        self.stopId = data.stop ?? ""
        self.bound = data.bound ?? ""
        self.serviceType = data.service_type ?? ""
        self.seq = data.seq ?? ""
    }
    
    init(route: String, stopId: String, bound: String, serviceType: String, seq: String){
        self.route = route
        self.stopId = stopId
        self.bound = bound
        self.serviceType = serviceType
        self.seq = seq
    }
    
    var sequence: Int{
        return Int(self.seq) ?? -1
    }
    
    var stop: KmbStop?{
        return KmbManager.getStop(stopId: self.stopId)
    }
}
