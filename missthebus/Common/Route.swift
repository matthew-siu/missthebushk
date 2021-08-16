//
//  Route.swift
//  missthebus
//
//  Created by Matthew Siu on 13/7/2021.
//

import Foundation

class Route: Codable{
    var company: BusCompany
    var route: String
    var origEn: String?
    var origTc: String?
    var origSc: String?
    var destEn: String?
    var destTc: String?
    var destSc: String?
    
    init(company: BusCompany, data: KmbRouteResponse.KmbRouteData){
        self.company = company
        self.route = data.route ?? ""
        self.origEn = data.orig_en
        self.origTc = data.orig_tc
        self.origSc = data.orig_sc
        self.destEn = data.dest_en
        self.destTc = data.dest_tc
        self.destSc = data.dest_sc
    }
    
    var originStop: String {
        switch currentLanguage{
            case .english: return origEn ?? ""
            case .traditionalChinese: return origTc ?? ""
            case .simplifiedChinese: return origSc ?? ""
        }
    }
    
    var destStop: String {
        switch currentLanguage{
            case .english: return destEn ?? ""
            case .traditionalChinese: return destTc ?? ""
            case .simplifiedChinese: return destSc ?? ""
        }
    }
}


class RouteMetadata: Codable{
    let routeNum: String
    let bound: String
    let serviceType: String
    init(_ routeNum: String, _ bound: String, _ serviceType: String){
        self.routeNum = routeNum
        self.bound = bound
        self.serviceType = serviceType
    }
}


enum BusCompany: String, Codable{
    case KMB = "KMB"
    case LWB = "LWB"
    case CTB = "CTB"
    case NWTB = "NWTB"
    case none = "none"
}
