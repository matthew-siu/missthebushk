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
    var status: Status
    
    var startTime: Date
    var endTime: Date?
    var period: [Int]?
    
    var routes = [Route]()
    
    class Route: Codable{
        var routeNum: String
        var bound: String
        var serviceType: String
        var stopIndex: [Int] // stop sequence
        
        init(route: RouteMetadata, stopIndex: [Int]){
            self.routeNum = route.routeNum
            self.bound = route.bound
            self.serviceType = route.serviceType
            self.stopIndex = stopIndex
        }
        
        func getRoute() -> KmbRoute?{
            return KmbManager.getRoute(route: self.routeNum, bound: self.bound, serviceType: self.serviceType)
        }
        
        func getStop(at index: Int) -> KmbRouteStop?{
            return self.getRoute()?.stopList[self.stopIndex[index]]
        }
        
        func getStops() -> [KmbRouteStop?]{
            return self.stopIndex.enumerated().map { (i, seq) in
                return self.getRoute()?.stopList[seq]
            }
        }
        
        func updateStopIndex(_ stopIndex: [Int]){
            self.stopIndex = stopIndex
        }
    }
    
    enum Status: String, Codable{
        case ACTIVE = "ACTIVE"
        case PROCESSING = "PROCESSING"
        case INACTIVE = "INACTIVE"
    }
    
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
        self.startTime = time
        self.status = .ACTIVE
    }
    
    var oneTimeOnly: Bool{
        return (self.period == nil || self.period?.count == 0)
    }
    
    var neverEnd: Bool{
        return (self.endTime == nil)
    }
    
    
}
