//
//  CtbNwfbStopAPIRepository.swift
//  missthebus
//
//  Created by Chopin on 22/8/2021.
//

import Foundation
import Alamofire

class CtbNwfbStopAPIRepository: APIRepository<CtbNwfbStopResponse> {
    
    var stopId: String = ""
    
    override var path: String {
        return "stop/\(self.stopId)"
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
    
    init(stopId: String) {
        self.stopId = stopId
        let request = CtbNwfbStopRequest()
        super.init(request: request)
    }
}

struct CtbNwfbStopRequest: APIRequest {
    
}


struct CtbNwfbStopResponse: APIResponse {
    let type: String?
    let version: String?
    let generated_timestamp: String?
    let data: CtbNwfbStopData?
    
    struct CtbNwfbStopData: APIResponse {
        let stop: String?
        let name_tc: String?
        let name_en: String?
        let name_sc: String?
        let lat: String?
        let long: String?
        let data_timestamp: String?
    }
}


