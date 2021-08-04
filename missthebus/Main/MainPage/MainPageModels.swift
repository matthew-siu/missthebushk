//
//  MainPageModels.swift
//  missthebus
//
//  Created by Matthew Siu on 6/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Models will go here
// Defines request, response and corresponding view models
enum MainPage
{
    
    struct BookmarkItem{
        let index: Int
        let stopId: String
        let routeNum: String
        let bound: String
        let serviceType: String
        let company: BusCompany
        let destStop: String
        let currentStop: String
    }
    
    struct ETAItem {
        let stopId: String
        let eta1: String?
        let eta2: String?
        let eta3: String?
        
        var etaList: [String?] {
            return [self.eta1, self.eta2, self.eta3]
        }
    }
    
    enum DisplayItem
    {
        struct Request
        {
        }
        struct Response
        {
        }
        struct ViewModel{
            let bookmarkItems: [BookmarkItem]
        }
        struct ETAViewModel{
            var etaList = [ETAItem]()
            
        }
    }
}
