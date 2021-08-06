//
//  StopReminder.swift
//  missthebus
//
//  Created by Matthew Siu on 28/7/2021.
//

import Foundation

class StopReminder: Codable{
    
    var id: String
    var name: String?
    var type: ReminderType?
    var isActivated = false
    
    var routeNum: String?
    var bound: String?
    var serviceType: String?
    var company: BusCompany?
    var stopId: String?
    
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
    
    init(time: Date){
        self.id = UUID().uuidString
        self.time = time
        self.isActivated = true
    }
    
    var oneTimeOnly: Bool{
        return (period == nil || period?.count == 0)
    }
    
    var currentStop: String?{
        guard let stopId = self.stopId else{
            return nil
        }
        return KmbManager.getStop(stopId: stopId)?.name
    }
    
    var destStop: String?{
        guard let routeNum = self.routeNum, let bound = self.bound, let serviceType = self.serviceType else{
            return nil
        }
        return KmbManager.getRoute(route: routeNum, bound: bound, serviceType: serviceType)?.destStop
    }
    
    var stop: KmbStop?{
        guard let stopId = self.stopId else{
            return nil
        }
        return KmbManager.getStop(stopId: stopId)
        
    }
    
    var route: KmbRoute?{
        guard let routeNum = self.routeNum, let bound = self.bound, let serviceType = self.serviceType else{
            return nil
        }
        return KmbManager.getRoute(route: routeNum, bound: bound, serviceType: serviceType)
    }
    
    func printDetails(){
//        print("\(self.name) | [\(self.routeNum)-\(self.bound)-\(self.serviceType)] | \(self.type.rawValue) | \(self.time) | \(String(describing: self.period))")
    }
}
