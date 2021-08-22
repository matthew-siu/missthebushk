//
//  NlbRoutes.swift
//  missthebus
//
//  Created by Chopin on 22/8/2021.
//

import Foundation

struct NlbRoutes: Codable {
    let routes: [NlbRouteData]
    
    
    struct NlbRouteData: Codable {
        let routeId: String
        let routeNo: String?
        let routeName_c: String?
        let routeName_s: String?
        let routeName_e: String?
        let overnightRoute: String?
        let specialRoute: String?
    }
}
