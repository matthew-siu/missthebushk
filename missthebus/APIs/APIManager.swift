//
//  APIManager.swift
//  clp-rollcall
//
//  Created by Ding Lo on 1/9/2020.
//  Copyright © 2020 Ding Lo. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

public class API {
    // Network Configuration
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()

    // Operation queue
    fileprivate static var _globalOperationQueue: OperationQueue?
    static var globalOperationQueue: OperationQueue {
        if let queue = _globalOperationQueue {
            return queue
        }
        else {
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
            _globalOperationQueue = queue
            return queue
        }
    }
    
    // Alamofire manager
    static var _manager: SessionManager?
    public static var manager: SessionManager {
        if let manager = self._manager {
            return manager
        }

        let config = URLSessionConfiguration.default
        config.httpCookieStorage = HTTPCookieStorage.shared
        let manager = SessionManager.init(configuration: config)
        
        manager.startRequestsImmediately = false
        self._manager = manager
        return manager
    }
    
    public static func updateManager(sessionConfig: URLSessionConfiguration, serverTrust: ServerTrustPolicyManager? = nil) {
        self._manager = Alamofire.SessionManager(configuration: sessionConfig, serverTrustPolicyManager: serverTrust)
        
        // Bypass all challenge
        self._manager?.delegate.sessionDidReceiveChallenge = {
            session, challenge in
            guard let trust = challenge.protectionSpace.serverTrust else {
                return (.useCredential, nil)
            }
            
            let disposition = URLSession.AuthChallengeDisposition.useCredential
            let credential = URLCredential(trust: trust)
            return (disposition, credential)
        }
        
        
    }
}

// MARK: - API extension - KMB
class KMBAPI {
    public static func send<R: Repository>(repository: R, usingQueue queue: OperationQueue? = nil) -> Promise<SuccessResponse<R.ResponseType?>> {
        
        let repo: Promise<(R.ResponseType?, ResponseHeaders?)> = API.send(repository: repository, usingQueue: queue)
//        print("-----\nAPI: \(repository.urlPath)")
//        print("body: \(String(describing: repository.body))")
        
        // header treatment
        let processedRepo = repo.then { (body, headers) -> Guarantee<SuccessResponse<R.ResponseType?>> in
            let responseObject = SuccessResponse<R.ResponseType?>.init(header: headers, body: body)    
//            print("API raw resp: \(String(describing: body).prefix(1000)) ...")
            
            return Guarantee<SuccessResponse<R.ResponseType?>> { seal in
                seal(responseObject)
            }
        }
        
        return processedRepo
    }
}

extension URL {
    
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}
