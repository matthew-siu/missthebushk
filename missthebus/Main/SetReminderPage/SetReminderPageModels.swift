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
    
    struct RouteAndStop{
        let routeNum: String
        let bound: String
        let service: String
        let destStop: String
        let targetStops: [RouteStop]
    }
    
    struct RouteStop{
        let seq: Int
        let label: String
    }
    
    enum Mode {
        case CREATE, UPDATE
    }
    
    enum DisplayItem
    {
        struct Request // vc -> interactor
        {
            let reminderName: String
            let reminderType: StopReminder.ReminderType
            let time: Date
            let period: [Int]?
        }
        struct Response // interactor -> presenter
        {
        }
        struct ViewModel // presenter -> vc
        {
            let mode: Mode
            var reminderType: StopReminder.ReminderType = .OTHER
            var time: Date?
            var period: [Int]?
            static let nameSamples: [NameSample] = [
                NameSample(img: "tagGoToWork", name: "reminder_tag_work".localized(), type: .WORK),
                NameSample(img: "tagBackHome", name: "reminder_tag_off_work".localized(), type: .BACK_HOME),
                NameSample(img: "tagSchool", name: "reminder_tag_school".localized(), type: .SCHOOL),
                NameSample(img: "tagGathering", name: "reminder_tag_gathering".localized(), type: .GATHERING),
                NameSample(img: "tagDating", name: "reminder_tag_dating".localized(), type: .DATING),
                NameSample(img: "tagLastBus", name: "reminder_tag_last".localized(), type: .LAST_BUS),
                NameSample(img: "tagOther", name: "reminder_tag_other".localized(), type: .OTHER),
            ]
        }
        struct RouteAndStopViewModel{
            let routes: [RouteAndStop]
        }
    }
}
