//
//  CtbNwfbRouteAPIRepository.swift
//  missthebus
//
//  Created by Chopin on 22/8/2021.
//

import Foundation
import Alamofire

class CtbNwfbRouteAPIRepository: APIRepository<CtbNwfbRouteResponse> {
    
    enum Company: String{
        case CTB = "CTB"
        case NWFB = "NWFB"
    }
    
    var company: String = ""
    
    override var path: String {
        return "route/\(self.company)"
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
    
    init(company: Company) {
        self.company = company.rawValue
        let request = CtbNwfbRouteRequest()
        super.init(request: request)
    }
}

struct CtbNwfbRouteRequest: APIRequest {
    
}


struct CtbNwfbRouteResponse: APIResponse {
    let type: String?
    let version: String?
    let generated_timestamp: String?
    let data: [CtbNwfbRouteData]?
    
    struct CtbNwfbRouteData: APIResponse {
        let co: String?
        let route: String?
        let orig_tc: String?
        let orig_en: String?
        let orig_sc: String?
        let dest_tc: String?
        let dest_en: String?
        let dest_sc: String?
        let data_timestamp: String?
    }
}
