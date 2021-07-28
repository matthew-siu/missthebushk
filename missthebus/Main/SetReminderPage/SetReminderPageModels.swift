//
//  SetReminderPageModels.swift
//  missthebus
//
//  Created by Matthew Siu on 26/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Models will go here
// Defines request, response and corresponding view models
enum SetReminderPage
{
    struct NameSample {
        let img: String // img filename
        let name: String // i18n id
        let type: StopReminder.ReminderType
    }
    
    enum DisplayItem
    {
        struct Request
        {
        }
        struct Response
        {
            let route: KmbRoute
            let stop: KmbStop
        }
        struct ViewModel
        {
            let routeNum: Int
            let busCompany: BusCompany
            let destStopName: String
            let currentStopName: String
            static let nameSamples: [NameSample] = [
                NameSample(img: "bell", name: "Work", type: .WORK),
                NameSample(img: "bell2", name: "Back Home", type: .OFF),
                NameSample(img: "bookmark", name: "Dating", type: .DATING),
                NameSample(img: "bookmarked", name: "Gathering", type: .GATHERING),
            ]
        }
    }
}
