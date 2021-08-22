//
//  NlbRouteAPIRepository.swift
//  missthebus
//
//  Created by Chopin on 22/8/2021.
//

import Foundation
import Alamofire

class NlbRouteAPIRepository: APIRepository<NlbRouteResponse> {
    
    override var path: String {
        return "nlb/route.php?action=list"
    }
    
    override var baseURL: String {
        return Configs.Network.nlbURL
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
        let request = NlbRouteRequest()
        super.init(request: request)
    }
}

struct NlbRouteRequest: APIRequest {
    
}


struct NlbRouteResponse: APIResponse {
    let routes: [NlbRouteData]
    
    struct NlbRouteData: APIResponse {
        let routeId: String?
        let routeNo: String?
        let routeName_c: String?
        let routeName_s: String?
        let routeName_e: String?
        let overnightRoute: Int?
        let specialRoute: Int?
    }
}
