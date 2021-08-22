//
//  NlbManager.swift
//  missthebus
//
//  Created by Chopin on 22/8/2021.
//

import Foundation
import PromiseKit

class NlbManager{
    
    static func requestAllRoutes() -> Promise<NlbRouteResponse?> {
        
        let repo = NlbRouteAPIRepository()
        return Promise{ promise in
            NLBAPI.send(repository: repo)
                .done { (response) in
                    if let ref = response.body  {
                        promise.fulfill(ref)
                    } else {
                        promise.fulfill(nil)
                    }
                }
                .catch { (error) in
                    promise.reject(error)
            }
        }
    }
}
