//
//  NetworkError.swift
//  clp-rollcall
//
//  Created by Ding Lo on 1/9/2020.
//  Copyright © 2020 Ding Lo. All rights reserved.
//

import Foundation
import PromiseKit

public enum APIError: Hashable, CancellableError {
    
    // Connection error: there is issue in channel between client and server
    case connection
    
    // HTTP error: HTTP status code unexpected, i.e., out of range of 200 - 299
    case http(Int)
    
    // Server error: HTTP 5xx
    case server(code: Int, title: String, message: String)
    
    // Error Response
    case apiReason(reason: Codable)
    
    // Cancel error
    case cancelled
    
    // Timeout error
    case timeout

    // SSL
    case sslError
    
    // Unexpected Response: Response body are not expected, like, empty response that is not supposed to be
    case unexpectedResponse
}

// MARK: - Cancellation
public extension APIError {
    var isCancelled: Bool {
        return self == APIError.cancelled
    }
}

// MARK: - Hash logic
extension APIError {
    public static func ==(lhs: APIError, rhs: APIError) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var hashValue: Int {
        return String(describing: self).hashValue
    }
}

// MARK: - Helper
//class NetworkError {
//    static func getErrorCase(code: String?) -> CommonAlert.ErrorMsg {
//        if let statusCode = code {
//            if statusCode == CommonAPI.ErrorType.sessionTimeout.rawValue {
//                return .sessionTimeout
//            } else if statusCode == CommonAPI.ErrorType.loginInvalid.rawValue {
//                return .loginInvalid
//            } else if statusCode == CommonAPI.ErrorType.deviceErase.rawValue {
//                // remove staff list data
//                UserDefaults.standard.removeObject(forKey: Configs.UserDefault.staffList)
//                CommonAPI.removeMemberList()
//
//                return .sessionTimeout
//            } else if statusCode == CommonAPI.ErrorType.notOnSite.rawValue {
//                return .notOnSite
//            } else if statusCode == CommonAPI.ErrorType.eventActivated.rawValue {
//                return .eventActivated
//            } else if statusCode == CommonAPI.ErrorType.invalidCard.rawValue {
//                return .invalidCard
//            } else if statusCode == CommonAPI.ErrorType.noAdLogin.rawValue {
//                return .noAdIdLogin
//            }
//        }
//        return .generalError
//    }
//}
