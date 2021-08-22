//
//  KmbETAAPIRepository.swift
//  missthebus
//
//  Created by Matthew Siu on 21/7/2021.
//

import Foundation
import Alamofire

// get all routes: e.g. /route
// get one route: e.g. /eta/A60AE774B09A5E44/40/1
class KmbETAAPIRepository: APIRepository<KmbETAResponse> {
    
    var stopId: String = "" // stop id e.g. A60AE774B09A5E44
    var route: String = "" // route id e.g. 1A, 277X, 978
    var serviceType: String = "" // service type e.g. 1, 2, 3
    
    override var path: String {
        return "stop-eta/\(self.stopId)"
//        return "eta/\(self.stopId)/\(self.route)/\(self.serviceType)"
    }
    
    override var encoding: ParameterEncoding {
        return URLEncoding()
    }
    
    override var method: APIMethod {
        return .get
    }
    
    override var headers: HTTPHeaders {
        let headers = super.headers
        
        return headers
    }
    
    init(query: KmbETAQuery) {
        self.stopId = query.stopId
        self.route = query.route
        self.serviceType = query.serviceType
        let request = EmptyRequest()
        super.init(request: request)
    }
    
}

struct KmbETAQuery: APIQuery{
    let stopId: String
    let route: String
    let serviceType: String
}


struct KmbETAResponse: APIResponse {
    let type: String?
    let version: String?
    let generated_timestamp: String?
    let data: [KmbETAData]?
    
    struct KmbETAData: APIResponse {
        let co: String?
        let route: String?
        let dir: String?
        let service_type: Int?
        let seq: Int?
        let dest_en: String?
        let dest_tc: String?
        let dest_sc: String?
        let eta_seq: Int?
        let eta: String?
        let rmk_tc: String?
        let rmk_sc: String?
        let rmk_en: String?
        let data_timestamp: String?
        
        var rmk: String?{
            switch currentLanguage{
            case .english: return self.rmk_en
            case .traditionalChinese: return self.rmk_tc
            case .simplifiedChinese: return self.rmk_sc
            }
        }
    }
}



