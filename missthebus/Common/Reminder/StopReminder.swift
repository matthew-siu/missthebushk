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
    
    var routes = [StopReminderRoute]()
    
    class StopReminderRoute: Codable{
        var routeId: String
        var routeNum: String
        var bound: String
        var serviceType: String
        var stopIndex: [Int] // stop sequence
        
        init(route: RouteMetadata, stopIndex: [Int]){
            self.routeId = route.routeId
            self.routeNum = route.routeNum
            self.bound = route.bound
            self.serviceType = route.serviceType
            self.stopIndex = stopIndex
        }
        
        func getRoute() -> Route?{
            return BusManager.getRoute(route: self.routeNum, bound: self.bound, serviceType: self.serviceType)
        }
        
        func getStop(at index: Int) -> RouteStop?{
            return self.getRoute()?.stopList[self.stopIndex[index]]
        }
        
        func getStops() -> [RouteStop?]{
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
    
    var isToday: Bool{
        if let day = Date().dayNumberOfWeek(){
            if let period = self.period{
                return period.contains(where: {$0 == day - 1})
            }
        }
        return false
    }
    
    var oneTimeOnly: Bool{
        return (self.period == nil || self.period?.count == 0)
    }
    
    var neverEnd: Bool{
        return (self.endTime == nil)
    }
    
    var displayPeriod: String{
        var periodStr = ""
        if (self.period?.count == 7){
            periodStr = "reminder_period_everyday".localized()
        }else if (self.period?.count == 0){
            periodStr = "reminder_period_once".localized()
        }else if let period = self.period?.map({StopReminder.daysOfWeek[$0].localized()}) {
            periodStr = period.joined(separator: " ")
        }
        return periodStr
    }
    
    var displayTime: String{
        return Utils.convertTime(time: self.startTime, toPattern: "HH:mm")
    }
    
    static func getTagViewModel(_ type: ReminderType) -> NameSample?{
        return nameSamples.first(where: {$0.type == type})
    }
    
    func printDetails(){
        var msg = "\(self.name ?? "") | \(self.type?.rawValue ?? "") | \(self.id)\n"
        msg += " time: \(self.startTime) | \(self.period ?? []) | neverEnd = \(self.neverEnd)\n Routes: \(self.routes.count)"
        for (index, route) in self.routes.enumerated(){
            msg += "\n \(index): \(route.routeNum) seq\(route.stopIndex) (total: \(route.stopIndex.count))"
        }
        print(msg)
    }
    
    
    
}

// for view model
extension StopReminder{
    
    struct NameSample: Codable {
        let img: String // img filename
        let name: String // i18n id
        let type: ReminderType
    }
    
    static let nameSamples: [NameSample] = [
        NameSample(img: "tagGoToWork", name: "reminder_tag_work".localized(), type: .WORK),
        NameSample(img: "tagBackHome", name: "reminder_tag_off_work".localized(), type: .BACK_HOME),
        NameSample(img: "tagSchool", name: "reminder_tag_school".localized(), type: .SCHOOL),
        NameSample(img: "tagGathering", name: "reminder_tag_gathering".localized(), type: .GATHERING),
        NameSample(img: "tagDating", name: "reminder_tag_dating".localized(), type: .DATING),
        NameSample(img: "tagLastBus", name: "reminder_tag_last".localized(), type: .LAST_BUS),
        NameSample(img: "tagOther", name: "reminder_tag_other".localized(), type: .OTHER),
    ]
    
    static let daysOfWeek: [String] = [
        "day_sun",
        "day_mon",
        "day_tue",
        "day_wed",
        "day_thu",
        "day_fri",
        "day_sat"
    ]
}
