//
//  NlbETAAPIRepository.swift
//  missthebus
//
//  Created by Chopin on 22/8/2021.
//

// http://www.nlb.com.hk/datagovhk/BusServiceOpenAPIDocumentation1.0.pdf

import Foundation
import Alamofire

class NlbETAAPIRepository: APIRepository<NlbETAResponse> {

    
    var routeId: String = ""
    var stopId: String = ""
    var language: String = ""
    
    override var path: String {
        return "nlb/route.php?action=estimatedArrivals"
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
    
    init(routeId: String, stopId: String) {
        self.routeId = routeId
        self.stopId = stopId
        switch currentLanguage {
        case .english:
            self.language = "en"
        case .traditionalChinese:
            self.language = "zh"
        case .simplifiedChinese:
            self.language = "cn"
        }
        let request = NlbETARequest(routeId: self.routeId, stopId: self.stopId, language: self.language)
        super.init(request: request)
    }
}

struct NlbETARequest: APIRequest {
    let routeId: String
    let stopId: String
    let language: String
}


struct NlbETAResponse: APIResponse {
    let message: String?
    let estimatedArrivals: [NlbETAData]?
    
    struct NlbETAData: APIResponse {
        let estimatedArrivalTime: String?
        let routeVariantName: String?
        let departed: Int?
        let noGPS: Int?
        let wheelChair: Int?
        let generateTime: String?
    }
}

