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
        struct ViewModel {
            let etaViews: [ETA]
        }
    }
}
