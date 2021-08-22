//
//  StopListPageModels.swift
//  missthebus
//
//  Created by Matthew Siu on 20/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Models will go here
// Defines request, response and corresponding view models
enum StopListPage
{
    
    enum Service{
        enum Request{
            struct Normal{
                let type = RequestType.NormalNavigation
                let route: Route
                let stop: KmbStop? // selected stop
    //            let selectedSeq: [Int]
            }
            
            struct GetRouteStops{
                let type = RequestType.GetRouteStopService
                let route: Route
                let stops: [Int] // selected stop
            }
        }
        
        enum Response{
            struct Normal{
                let route: Route
                var stop: KmbStop?
            }
            
            struct GetRouteStops{
                let route: Route
                var stops: [Int] // selected stop
            }
        }
    }
    
    enum RequestType{
        case GetRouteStopService
        case NormalNavigation
    }
    
    struct ETA {
        var company: BusCompany
        var seq: Int
        var display: String
        var remark: String?
    }
    
    struct BookMarkImgName {
        static let bookmark = "pin"
        static let bookmarked = "pinned"
    }
    
    enum DisplayItem {
        struct Request {
            
        }
        struct Response {
            let eta: [KmbETAResponse.KmbETAData]
        }
        struct ETAViewModel {
            let etaViews: [ETA]
        }
    }
}
