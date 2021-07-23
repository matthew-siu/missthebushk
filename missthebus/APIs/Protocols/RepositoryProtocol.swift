//
//  RepositoryProtocol.swift
//  clp-rollcall
//
//  Created by Ding Lo on 1/9/2020.
//  Copyright © 2020 Ding Lo. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Repository protocol
public protocol Repository {
    
    // Type define
    associatedtype ResponseType: APIResponse
    
    // HTTP Method
    var method: APIMethod { get }
    
    // Domain
    var baseURL: String { get }
    
    // Path
    var path: String? { get }
    
    // Encoding
    var encoding: Alamofire.ParameterEncoding { get }
    
    // Header
    var headers: HTTPHeaders { get }
    
    // Body
    var body: Alamofire.Parameters? { get }
    
    // Null
    var allowNil: Bool { get }
    
    // Reroute
    var allowReroute: Bool { get }
    
    // Full URL Path
    var urlPath: String { get }

}
