//
//  Stop.swift
//  missthebus
//
//  Created by Matthew Siu on 20/7/2021.
//

import Foundation

class Stop: Codable{
    
    var stopId: String
    var nameEn: String
    var nameTc: String
    var nameSc: String
    var lat: String
    var long: String
    
    init(data: KmbStopResponse.KmbStopData){
        self.stopId = data.stop ?? ""
        self.nameEn = data.name_en ?? ""
        self.nameTc = data.name_tc ?? ""
        self.nameSc = data.name_sc ?? ""
        self.lat = data.lat ?? ""
        self.long = data.long ?? ""
    }
    
    init(data: CtbNwfbStopResponse.CtbNwfbStopData){
        self.stopId = data.stop ?? ""
        self.nameEn = data.name_en ?? ""
        self.nameTc = data.name_tc ?? ""
        self.nameSc = data.name_sc ?? ""
        self.lat = data.lat ?? ""
        self.long = data.long ?? ""
    }
    
    init(data: NlbRouteStopResponse.NlbRouteStopData){
        self.stopId = data.stopId ?? ""
        self.nameEn = data.stopName_e ?? ""
        self.nameTc = data.stopName_c ?? ""
        self.nameSc = data.stopName_s ?? ""
        self.lat = data.latitude ?? ""
        self.long = data.longitude ?? ""
    }
    
    var name: String{
        switch currentLanguage{
        case .english: return nameEn.capitalized
        case .traditionalChinese: return nameTc
        case .simplifiedChinese: return nameSc
        }
    }
    
    var latitude: Double?{
        return Double(self.lat) ?? nil
    }
    
    var longitude: Double?{
        return Double(self.long) ?? nil
    }
    
    func printSelf(){
        print("Stop: \(self.stopId) | \(self.nameTc)")
    }
}
