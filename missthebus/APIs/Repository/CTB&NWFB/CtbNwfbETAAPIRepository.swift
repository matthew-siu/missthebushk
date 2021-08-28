//
//  CtbNwfbETAAPIRepository.swift
//  missthebus
//
//  Created by Chopin on 22/8/2021.
//

import Foundation
import Alamofire

class CtbNwfbETAAPIRepository: APIRepository<CtbNwfbETAResponse> {
    
    enum Company: String{
        case CTB = "CTB"
        case NWFB = "NWFB"
    }
    
    var company: String = ""
    var routeNum: String = ""
    var stopId: String = ""
    
    override var path: String {
        return "eta/\(self.company)/\(self.stopId)/\(self.routeNum)"
    }
    
    override var baseURL: String {
        return Configs.Network.ctbnwfbURL
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
    
    init(query: CtbNwfbETAQuery) {
        self.company = (query.company == .CTB) ? Company.CTB.rawValue : Company.NWFB.rawValue
        self.stopId = query.stopId
        self.routeNum = query.routeNum
        let request = CtbNwfbETARequest()
        super.init(request: request)
    }
}

struct CtbNwfbETARequest: APIRequest {
    
}


struct CtbNwfbETAQuery: APIQuery{
    let company: BusCompany
    let stopId: String
    let routeNum: String
}

struct CtbNwfbETAResponse: APIResponse {
    let type: String?
    let version: String?
    let generated_timestamp: String?
    let data: [CtbNwfbETAData]?
    
    struct CtbNwfbETAData: APIResponse {
        let co: String?
        let route: String?
        let dir: String?
        let seq: Int?
        let stop: String?
        let eta: String?
        let eta_seq: Int?
        let dest_tc: String?
        let dest_en: String?
        let dest_sc: String?
        let rmk_tc: String?
        let rmk_en: String?
        let rmk_sc: String?
        let data_timestamp: String?
        
        var rmk: String? {
            switch currentLanguage{
                case .english: return self.rmk_en
                case .traditionalChinese: return self.rmk_tc
                case .simplifiedChinese: return self.rmk_sc
            }
        }
    }
    
}
