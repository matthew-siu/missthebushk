//
//  KmbRoute.swift
//  missthebus
//
//  Created by Matthew Siu on 13/7/2021.
//

import UIKit

class Route: Codable {
    
    var company: BusCompany
    var route: String
    var origEn: String
    var origTc: String
    var origSc: String
    var destEn: String
    var destTc: String
    var destSc: String
    var stopList: [RouteStop] = []
    
    var routeId: String
    
    var serviceType: String
    var bound: String // O || I

    init(data: KmbRouteResponse.KmbRouteData){
        self.company = .KMB
        self.route = data.route ?? ""
        self.origEn = data.orig_en ?? ""
        self.origTc = data.orig_tc ?? ""
        self.origSc = data.orig_sc ?? ""
        self.destEn = data.dest_en ?? ""
        self.destTc = data.dest_tc ?? ""
        self.destSc = data.dest_sc ?? ""
        self.serviceType = data.service_type ?? ""
        self.bound = data.bound ?? ""
        // NLB data
        self.routeId = ""
    }
    
    init(data: CtbNwfbRouteResponse.CtbNwfbRouteData, bound: String){
        switch (data.co){
            case "CTB" : self.company = .CTB
            case "NWFB" : self.company = .NWFB
            default: self.company = .none
        }
        self.route = data.route ?? ""
        self.origEn = data.orig_en ?? ""
        self.origTc = data.orig_tc ?? ""
        self.origSc = data.orig_sc ?? ""
        self.destEn = data.dest_en ?? ""
        self.destTc = data.dest_tc ?? ""
        self.destSc = data.dest_sc ?? ""
        self.bound = bound
        // KMB data
        self.serviceType = ""
        // NLB
        self.routeId = ""
    }
    
    init(data: NlbRouteResponse.NlbRouteData){
        self.company = .NLB
        self.routeId = data.routeId ?? ""
        self.route = data.routeNo ?? ""
        self.origEn = ""
        self.origTc = ""
        self.origSc = ""
        self.destEn = ""
        self.destTc = ""
        self.destSc = ""
        if let routeName_e = data.routeName_e {
            let routeNames = routeName_e.components(separatedBy: " > ")
            self.origEn = routeNames[0]
            self.destEn = routeNames[1]
        }
        if let routeName_c = data.routeName_c {
            let routeNames = routeName_c.components(separatedBy: " > ")
            self.origTc = routeNames[0]
            self.destTc = routeNames[1]
        }
        if let routeName_s = data.routeName_s {
            let routeNames = routeName_s.components(separatedBy: " > ")
            self.origSc = routeNames[0]
            self.destSc = routeNames[1]
        }
        // KMB
        self.serviceType = ""
        self.bound = ""
    }
    
    var originStop: String {
        switch currentLanguage{
            case .english: return origEn.capitalized
            case .traditionalChinese: return origTc
            case .simplifiedChinese: return origSc
        }
    }
    
    var destStop: String {
        switch currentLanguage{
            case .english: return destEn.capitalized
            case .traditionalChinese: return destTc
            case .simplifiedChinese: return destSc
        }
    }
    
    var routeNumParser: [String]{
        let num1 = route.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
        var parser = route.split(usingRegex: num1)
        parser.insert(num1, at: 1)
        return parser
    }
    
    func appendStopList(_ stop: RouteStop){
        stopList.append(stop)
    }

    func clearStopList(){
        self.stopList.removeAll()
    }
    
    func printSelf(){
        print("\(self.route) (\(self.company) | \(self.routeId) | \(String(describing: self.origTc))->\(String(describing: self.destTc)) | \(String(describing: self.bound)) | \(String(describing: self.serviceType)) | \(String(describing: self.stopList.count)) stops")
    }
}


enum BusCompany: String, Codable{
    case KMB = "KMB"
    case CTB = "CTB"
    case NWFB = "NWFB"
    case NLB = "NLB"
//    case LWB = "LWB"
    case none = "none"
}

class RouteMetadata: Codable, Equatable{
    
    let routeNum: String
    let bound: String
    let serviceType: String
    init(_ routeNum: String, _ bound: String, _ serviceType: String){
        self.routeNum = routeNum
        self.bound = bound
        self.serviceType = serviceType
    }
    
    static func == (lhs: RouteMetadata, rhs: RouteMetadata) -> Bool {
        return (lhs.routeNum == rhs.routeNum && lhs.bound == rhs.bound && lhs.serviceType == rhs.serviceType)
    }
}
