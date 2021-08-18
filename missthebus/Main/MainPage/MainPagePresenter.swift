//
//  MainPagePresenter.swift
//  missthebus
//
//  Created by Matthew Siu on 6/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Presentation logic goes here
protocol MainPagePresentationLogic
{
    func displayBookmarks(bookmarks: [StopBookmark])
    func displayReminders(reminders: [StopReminder])
    func updateETAs(query: KmbETAQuery, bound: String, data: [KmbETAResponse.KmbETAData])
}

// MARK: - Presenter main body
class MainPagePresenter: MainPagePresentationLogic
{
    weak var viewController: MainPageDisplayLogic?
    
    var reminders = [StopReminder]()
    var bookmarks = [StopBookmark]()
    var etaViewModel = MainPage.DisplayItem.Bookmarks.ETAViewModel()
}

// MARK: - Presentation receiver
extension MainPagePresenter {
    
    func displayBookmarks(bookmarks: [StopBookmark]){
        self.bookmarks = bookmarks
        let bookMarkItems = bookmarks.enumerated().map{(index, bookmark) in
            return MainPage.BookmarkItem(index: index, stopId: bookmark.stopId, routeNum: bookmark.routeNum, bound: bookmark.bound, serviceType: bookmark.serviceType, company: bookmark.company, destStop: bookmark.destStop ?? "", currentStop: bookmark.currentStop ?? "")
        }
        let viewModel = MainPage.DisplayItem.Bookmarks.ViewModel(bookmarkItems: bookMarkItems)
        self.viewController?.displayBookmarks(viewModel: viewModel)
    }
    
    func displayReminders(reminders: [StopReminder]){
        var reminderItems = [MainPage.ReminderItem]()
        for reminder in reminders{
//            var periodStr = ""
//            if (reminder.period?.count == 7){
//                periodStr = "reminder_period_everyday".localized()
//            }else if let period = reminder.period?.map({String($0)}) {
//                periodStr = period.joined(separator: " ")
//            }
            var routes = [MainPage.ReminderItem.ReminderRouteItem]()
            for route in reminder.routes{
                routes.append(MainPage.ReminderItem.ReminderRouteItem(company: route.getRoute()?.company ?? .none, routeNum: route.routeNum))
            }
            
            reminderItems.append(MainPage.ReminderItem(id: reminder.id, name: (reminder.name ?? ""), period: reminder.displayPeriod, startTime: reminder.displayTime, type: reminder.type ?? .OTHER, routes: routes))
        }
        let viewModel = MainPage.DisplayItem.Reminders.ViewModel(reminderItems: reminderItems)
        self.viewController?.displayReminders(viewModel: viewModel)
    }
    
    func updateETAs(query: KmbETAQuery, bound: String, data: [KmbETAResponse.KmbETAData]){
        var etas = [String]()
        for eta in data{
            if (eta.co == BusCompany.KMB.rawValue){
                if (eta.route == query.route && eta.dir == bound && String(eta.service_type ?? -1) == query.serviceType){
                    etas.append(KmbManager.getETA(raw: eta.eta))
                }
            }
        }
        let eta1: String? = (etas.count >= 1) ? etas[0] : nil
        let eta2: String? = (etas.count >= 2) ? etas[1] : nil
        let eta3: String? = (etas.count >= 3) ? etas[2] : nil
        let route = RouteMetadata(query.route, bound, query.serviceType)
        let etaItem = MainPage.ETAItem(route: route, stopId: query.stopId, eta1: eta1, eta2: eta2, eta3: eta3)
        if let index = self.etaViewModel.etaList.firstIndex(where: {$0.stopId == query.stopId && $0.route == route}){
            self.etaViewModel.etaList[index] = etaItem
//            print("ETA \(query.route) [o] \(query.stopId) \(eta1) \(eta2) \(eta3)")
        }else{
//            print("ETA \(query.route) [+] \(query.stopId) \(eta1) \(eta2) \(eta3)")
            self.etaViewModel.etaList.append(etaItem)
        }
        self.viewController?.updateETAs(etaList: self.etaViewModel)
    }
}
