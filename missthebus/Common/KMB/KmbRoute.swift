//
//  KmbRoute.swift
//  missthebus
//
//  Created by Matthew Siu on 13/7/2021.
//

import UIKit

class KmbRoute: Codable {
    
    var company: BusCompany
    var route: String
    var origEn: String
    var origTc: String
    var origSc: String
    var destEn: String
    var destTc: String
    var destSc: String
    
    var serviceType: String
    var bound: String // O || I
    var stopList: [KmbRouteStop] = []

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
    
    func appendStopList(_ stop: KmbRouteStop){
        stopList.append(stop)
    }

    func clearStopList(){
        self.stopList.removeAll()
    }
    
    func printSelf(){
        print("\(self.route) | \(String(describing: self.origTc))->\(String(describing: self.destTc)) | \(String(describing: self.bound)) | \(String(describing: self.serviceType)) | \(String(describing: self.stopList.count)) stops")
    }
}
