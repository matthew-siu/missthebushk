//
//  KmbStopAPIRepository.swift
//  missthebus
//
//  Created by Matthew Siu on 13/7/2021.
//

import Foundation
import Alamofire

// get all routes: e.g. /stop
// get one route: e.g. /stop/18492910339410B1
class KmbStopAPIRepository: APIRepository<KmbStopResponse> {
    
    var id: String = "" // stop id
    
    override var path: String {
        return "stop/\(self.id)"
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
        let request = KmbStopRequest()
        super.init(request: request)
    }
    
    init(id: String) {
        self.id = id
        let request = KmbStopRequest()
        super.init(request: request)
    }
    
}

struct KmbStopRequest: APIRequest {
    
}


struct KmbStopResponse: APIResponse {
    let type: String?
    let version: String?
    let generated_timestamp: String?
    let data: [KmbStopData]?
    
    
    struct KmbStopData: APIResponse {
        let stop: String?
        let name_en: String?
        let name_tc: String?
        let name_sc: String?
        let lat: String?
        let long: String?
    }
}

