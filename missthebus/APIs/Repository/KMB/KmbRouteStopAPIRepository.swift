//
//  KmbRouteStopAPIRepository.swift
//  missthebus
//
//  Created by Matthew Siu on 13/7/2021.
//

import Foundation
import Alamofire

// Get All Stops mapping with route
class KmbRouteStopAPIRepository: APIRepository<KmbRouteStopResponse> {
    
    
    override var path: String {
        return "route-stop"
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
        let request = KmbRouteStopRequest()
        super.init(request: request)
    }
    
}

struct KmbRouteStopRequest: APIRequest {
    
}


struct KmbRouteStopResponse: APIResponse {
    let type: String?
    let version: String?
    let generated_timestamp: String?
    let data: [KmbRouteStopData]?
    
    
    struct KmbRouteStopData: APIResponse {
        let route: String?
        let bound: String?
        let service_type: String?
        let seq: String?
        let stop: String?
    }
}

