//
//  RequestProtocol.swift
//  clp-rollcall
//
//  Created by Ding Lo on 1/9/2020.
//  Copyright © 2020 Ding Lo. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Request protocol
public typealias APIRequest = Codable
public class EmptyRequest: APIRequest {
    public init() {}
}

// MARK: - Prevent importing alamofire in every repository
public enum APIMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
    
    var alamofireMethod: HTTPMethod? {
        return HTTPMethod(rawValue: self.rawValue)
    }
}
