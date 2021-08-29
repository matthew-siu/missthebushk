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
        return "nlb/stop.php?action=estimatedArrivals"
    }
    
    override var baseURL: String {
        return Configs.Network.nlbURL
    }
    
    override var encoding: ParameterEncoding {
        if (method == .post){
            return JSONEncoding()
        }else if (method == .get){
            return URLEncoding()
        }else{
            return URLEncoding.methodDependent
        }
    }
    
    override var method: APIMethod {
        return .post
    }
    
    override var headers: HTTPHeaders {
        var headers = super.headers
        headers["Content-Type"] = "application/json"
        
        return headers
    }
    
    init(query: NlbETAQuery) {
        self.routeId = query.routeId
        self.stopId = query.stopId
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

struct NlbETAQuery: APIQuery{
    let routeId: String
    let routeNum: String
    let stopId: String
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

