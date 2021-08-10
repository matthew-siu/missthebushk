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
    
    struct Route: Codable{
        var routeNum: String
        var bound: String
        var serviceType: String
        var stopIndex: [Int] // stop sequence
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
