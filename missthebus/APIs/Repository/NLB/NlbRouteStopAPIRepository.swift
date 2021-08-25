//
//  NlbRouteStopAPIRepository.swift
//  missthebus
//
//  Created by Chopin on 22/8/2021.
//

import Foundation
import Alamofire

class NlbRouteStopAPIRepository: APIRepository<NlbRouteStopResponse> {

    
    var routeId: String = ""
    
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
        return .post
    }
    
    override var headers: HTTPHeaders {
        let headers = super.headers
        
        return headers
    }
    
    init(routeId: String) {
        self.routeId = routeId
        let request = NlbRouteStopRequest(routeId: self.routeId)
        super.init(request: request)
    }
}

struct NlbRouteStopRequest: APIRequest {
    let routeId: String
}


struct NlbRouteStopResponse: APIResponse {
    let routes: [NlbRouteStopData]?
    
    struct NlbRouteStopData: APIResponse {
        let stopId: String?
        let stopName_c: String?
        let stopName_s: String?
        let stopName_e: String?
        let stopLocation_c: String?
        let stopLocation_s: String?
        let stopLocation_e: String?
        let latitude: String?
        let longitude: String?
        let fare: String?
        let fareHoliday: String?
        let someDepartureObserveOnly: Int?
    }
}
