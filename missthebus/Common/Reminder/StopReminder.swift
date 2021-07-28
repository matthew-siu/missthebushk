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
    
    var route: String
    var bound: String
    var serviceType: String
    var company: BusCompany
    var stopId: String
    
    var time: Date
    var period: [Int]?
    
    enum ReminderType: String, Codable {
        case WORK = "GOTOWORK"
        case OFF = "BACKHOME"
        case DATING = "DATING"
        case GATHERING = "GATHERING"
        case OTHER = "OTHER"
    }
    
    init(name: String, type: ReminderType, route: String, bound: String, serviceType: String, company: BusCompany, stopId: String, time: Date, period: [Int]?){
        self.id = UUID().uuidString
        self.name = name
        self.type = type
        self.route = route
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
}
