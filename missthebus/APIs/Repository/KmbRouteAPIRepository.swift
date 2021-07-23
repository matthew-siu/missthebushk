//
//  KmbRouteAPIRepository.swift
//  missthebus
//
//  Created by Matthew Siu on 9/7/2021.
//

import Foundation
import Alamofire

// get all routes: e.g. /route
// get one route: e.g. /route/1A
class KmbRouteAPIRepository: APIRepository<KmbRouteResponse> {
    
    var id: String = "" // route id e.g. 1A, 277X, 978
    
    override var path: String {
        return "route/\(self.id)"
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
    
    init() {
        let request = KmbRouteRequest()
        super.init(request: request)
    }
    
    init(id: String) {
        self.id = id
        let request = KmbRouteRequest()
        super.init(request: request)
    }
    
}

struct KmbRouteRequest: APIRequest {
    
}


struct KmbRouteResponse: APIResponse {
    let type: String?
    let version: String?
    let generated_timestamp: String?
    let data: [KmbRouteData]?
    
    
    struct KmbRouteData: APIResponse {
        let route: String?
        let bound: String?
        let service_type: String?
        let orig_en: String?
        let orig_tc: String?
        let orig_sc: String?
        let dest_en: String?
        let dest_tc: String?
        let dest_sc: String?
    }
}
