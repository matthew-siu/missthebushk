//
//  SearchPageModels.swift
//  missthebus
//
//  Created by Matthew Siu on 7/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Models will go here
// Defines request, response and corresponding view models
enum SearchPage
{
    struct RouteItem{
        let routeNum: String
        let bound: String
        let serviceType: String
        let company: BusCompany
        let destStop: String
        let origStop: String
    }
    
    enum DisplayItem
    {
        struct Request
        {
        }
        struct Response
        {
        }
        struct ViewModel
        {
            let routeList: [RouteItem]
        }
    }
}
