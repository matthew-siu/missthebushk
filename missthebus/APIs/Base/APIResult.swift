//
//  APIResult.swift
//  clp-rollcall
//
//  Created by Ding Lo on 1/9/2020.
//  Copyright © 2020 Ding Lo. All rights reserved.
//

import Foundation

// MARK: - Associate type
public typealias ResponseHeaders = [AnyHashable: Any]

// MARK: - Result
public enum APIResult<Value> {
    case success(Value?, ResponseHeaders?)
    case failure(APIError)
}
