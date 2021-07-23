//
//  APIRepository.swift
//  clp-rollcall
//
//  Created by Ding Lo on 1/9/2020.
//  Copyright © 2020 Ding Lo. All rights reserved.
//

import Foundation
import Alamofire

class APIRepository<Response: APIResponse>: Repository {
    
    public typealias ResponseType = Response
    
    // Dependent properties
    public let request: APIRequest
    
    public var method: APIMethod {
        return .get
    }
    
    public var baseURL: String {
        return Configs.Network.kmbURL
    }
    
    public var path: String? {
        return nil
    }
    
    public var encoding: ParameterEncoding {
        return URLEncoding.methodDependent
    }
    
    public var headers: [String : String] {
        var headers: [String: String] = [:]
        
        return headers
    }
    
    public var body: Parameters? {
        return self.request.dictionary
    }
    
    public var allowNil: Bool {
        return true
    }
    
    public var allowReroute: Bool {
        return false
    }
    
    public var urlPath: String {
        var urlPath = self.baseURL
        if let aPath = self.path {
            urlPath += "/\(aPath)"
        }
        
        return urlPath
    }
    
    public init(request: APIRequest) {
        self.request = request
    }
    
}
