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
    
    enum Tab: Int{
        case Upcoming = 0
        case Bookmarks = 1
        case Reminders = 2
        case Search = 3
    }
    
    struct BookmarkItem{
        let stopId: String
        let routeNum: String
        let bound: String
        let serviceType: String
        let company: BusCompany
        let destStop: String
        let currentStop: String
        
        var routeMetadata: RouteMetadata{
            return RouteMetadata(routeNum, bound, serviceType)
        }
    }
    
    struct ReminderItem{
        let id: String
        let name: String
        let period: String
        let startTime: String
        let type: StopReminder.ReminderType
        let routes: [ReminderRouteItem]
        
        struct ReminderRouteItem{
            let company: BusCompany
            let routeNum: String
        }
    }
    
    struct UpcomingReminderItem{
        let header: UpcomingHeader
        let routes: [ReminderRouteItem]
        
        struct UpcomingHeader{
            let id: String
            let name: String
            let period: String
            let startTime: Date
            let type: StopReminder.ReminderType
        }
        
        struct ReminderRouteItem{
            let company: BusCompany
            let routeNum: String
            let destStop: String
            let stops: [ReminderRouteStopItem]
            
        }
        
        struct ReminderRouteStopItem{
            let stop: String
            var eta1: String = ""
            var eta2: String = ""
            var eta3: String = ""
        }
    }
    
    struct ETAItem {
        
        let route: RouteMetadata
        let stopId: String
        let company: BusCompany
        let eta1: String?
        let eta2: String?
        let eta3: String?
        
        var etaList: [String?] {
            return [self.eta1, self.eta2, self.eta3]
        }
    }
    
    struct BasicViewModel{
        var headerImgName: String
        var headerLabel: String
        var noItemLabel = ""
    }
    
    enum DisplayItem
    {
        struct TabBarItems{
            static let upcoming = "main_upcoming_reminder"
            static let bookmarks = "main_bookmark"
            static let reminders = "main_reminders"
            static let search = "main_search"
        }
        
        enum Bookmarks{
            struct ViewModel{
                let title = BasicViewModel(headerImgName: "pin", headerLabel: "main_bookmark".localized(), noItemLabel: "main_no_bookmark".localized())
                var bookmarkItems: [BookmarkItem] = []
            }
            struct ETAViewModel{
                var etaList = [ETAItem]()
            }
        }
        
        enum Reminders{
            struct ViewModel{
                let title = BasicViewModel(headerImgName: "bell", headerLabel: "main_reminders".localized(), noItemLabel: "main_no_reminder".localized())
                var reminderItems: [ReminderItem] = []
            }
        }
        
        enum UpcomingReminders{
            struct ViewModel{
                let title = BasicViewModel(headerImgName: "recent", headerLabel: "main_upcoming_reminder".localized(), noItemLabel: "main_no_upcoming_reminder".localized())
                var upcomingReminder: UpcomingReminderItem?
            }
            struct ETAViewModel{
                var etaList = [ETAItem]()
            }
        }
    }
}
