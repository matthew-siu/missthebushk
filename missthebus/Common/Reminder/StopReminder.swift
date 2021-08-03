//
//  StopReminder.swift
//  missthebus
//
//  Created by Matthew Siu on 28/7/2021.
//

import Foundation

class StopReminder: Codable{
    
    var id: String
    var name: String
    var type: ReminderType
    var isActivated = false
    
    var routeNum: String
    var bound: String
    var serviceType: String
    var company: BusCompany
    var stopId: String
    
    var time: Date
    var period: [Int]?
    
    enum ReminderType: String, Codable {
        case WORK = "GOTOWORK"
        case BACK_HOME = "BACKHOME"
        case SCHOOL = "SCHOOL"
        case DATING = "DATING"
        case GATHERING = "GATHERING"
        case LAST_BUS = "LASTBUS"
        case OTHER = "OTHER"
    }
    
    init(name: String, type: ReminderType, routeNum: String, bound: String, serviceType: String, company: BusCompany, stopId: String, time: Date, period: [Int]?){
        self.id = UUID().uuidString
        self.name = name
        self.type = type
        self.routeNum = routeNum
        self.bound = bound
        self.serviceType = serviceType
        self.company = company
        self.time = time
        self.stopId = stopId
        self.period = period
        self.isActivated = true
    }
    
    var oneTimeOnly: Bool{
        return (period == nil || period?.count == 0)
    }
    
    var currentStop: String?{
        return KmbManager.getStop(stopId: self.stopId)?.name
    }
    
    var destStop: String?{
        return KmbManager.getRoute(route: self.routeNum, bound: self.bound, serviceType: self.serviceType)?.destStop
    }
    
    var stop: KmbStop?{
        return KmbManager.getStop(stopId: self.stopId)
        
    }
    
    var route: KmbRoute?{
        return KmbManager.getRoute(route: self.routeNum, bound: self.bound, serviceType: self.serviceType)
    }
    
    func printDetails(){
        print("\(self.name) | [\(self.routeNum)-\(self.bound)-\(self.serviceType)] | \(self.type.rawValue) | \(self.time) | \(String(describing: self.period))")
    }
}
