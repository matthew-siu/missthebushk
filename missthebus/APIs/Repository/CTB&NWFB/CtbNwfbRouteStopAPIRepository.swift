//
//  CtbNwfbRouteStopAPIRepository.swift
//  missthebus
//
//  Created by Chopin on 22/8/2021.
//

import Foundation
import Alamofire

class CtbNwfbRouteStopAPIRepository: APIRepository<CtbNwfbRouteStopResponse> {
    
    enum Company: String{
        case CTB = "CTB"
        case NWFB = "NWFB"
    }
    
    enum Bound: String{
        case Inbound = "inbound"
        case Outbound = "outbound"
    }
    
    var company: String = ""
    var routeNum: String = ""
    var bound: String = ""
    
    override var path: String {
        return "route-stop/\(self.company)/\(self.routeNum)/\(self.bound)"
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
    
    init(company: Company, routeNum: String, bound: Bound) {
        self.company = company.rawValue
        self.routeNum = routeNum
        self.bound = bound.rawValue
        let request = CtbNwfbRouteStopRequest()
        super.init(request: request)
    }
}

struct CtbNwfbRouteStopRequest: APIRequest {
    
}


struct CtbNwfbRouteStopResponse: APIResponse {
    let type: String?
    let version: String?
    let generated_timestamp: String?
    let data: [CtbNwfbRouteStopData]?
    
    struct CtbNwfbRouteStopData: APIResponse {
        let co: String?
        let route: String?
        let dir: String?
        let seq: Int?
        let stop: String?
        let data_timestamp: String?
    }
}

