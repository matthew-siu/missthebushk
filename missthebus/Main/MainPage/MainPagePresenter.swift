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
//    func displayUpcoming(reminder: StopReminder?)
    func updateETAs(query: KmbETAQuery?, bound: String, data: [KmbETAResponse.KmbETAData])
    func updateETAs(query: CtbNwfbETAQuery?, bound: String, data: [CtbNwfbETAResponse.CtbNwfbETAData])
    func updateETAs(query: NlbETAQuery?, bound: String, data: [NlbETAResponse.NlbETAData])
    
    
    func displayUpcoming(viewModel: MainPage.DisplayItem.UpcomingReminders.ViewModel)
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
        let bookMarkItems = bookmarks.map{(bookmark) in
            return MainPage.BookmarkItem(stopId: bookmark.stopId, routeNum: bookmark.routeNum, bound: bookmark.bound, serviceType: bookmark.serviceType, company: bookmark.company, destStop: bookmark.destStop ?? "", currentStop: bookmark.currentStop ?? "")
        }
        let viewModel = MainPage.DisplayItem.Bookmarks.ViewModel(bookmarkItems: bookMarkItems)
        self.viewController?.displayBookmarks(viewModel: viewModel)
    }
    
    func displayReminders(reminders: [StopReminder]){
        var reminderItems = [MainPage.ReminderItem]()
        for (reminder) in reminders{
            var routes = [MainPage.ReminderItem.ReminderRouteItem]()
            for route in reminder.routes{
                routes.append(MainPage.ReminderItem.ReminderRouteItem(company: route.getRoute()?.company ?? .none, routeNum: route.routeNum))
            }
            
            reminderItems.append(MainPage.ReminderItem(id: reminder.id, name: (reminder.name ?? ""), period: reminder.displayPeriod, startTime: reminder.displayTime, type: reminder.type ?? .OTHER, routes: routes))
        }
        let viewModel = MainPage.DisplayItem.Reminders.ViewModel(reminderItems: reminderItems)
        self.viewController?.displayReminders(viewModel: viewModel)
    }
    
//    func displayUpcoming(reminder: StopReminder?){
//    }
    
    func displayUpcoming(viewModel: MainPage.DisplayItem.UpcomingReminders.ViewModel){
        self.viewController?.displayUpcoming(viewModel: viewModel)
        
    }
    
    func updateETAs(query: KmbETAQuery?, bound: String, data: [KmbETAResponse.KmbETAData]){
        var etas = [String]()
        guard let query = query else {return}
        for eta in data{
            if (eta.route == query.route && eta.dir == bound && String(eta.service_type ?? -1) == query.serviceType){
                if let display = KmbManager.getETA(raw: eta.eta){
                    etas.append(display)
                }
            }
        }
        if (etas.count == 0){return}
        let eta1: String? = (etas.count >= 1) ? etas[0] : nil
        let eta2: String? = (etas.count >= 2) ? etas[1] : nil
        let eta3: String? = (etas.count >= 3) ? etas[2] : nil
        let route = RouteMetadata(query.route, bound, query.serviceType)
        let etaItem = MainPage.ETAItem(route: route, stopId: query.stopId, company: .KMB, eta1: eta1, eta2: eta2, eta3: eta3)
        if let index = self.etaViewModel.etaList.firstIndex(where: {$0.stopId == query.stopId && $0.route == route  && $0.company == .KMB}){
            self.etaViewModel.etaList[index] = etaItem
        }else{
            self.etaViewModel.etaList.append(etaItem)
        }
        self.viewController?.updateETAs(etaList: self.etaViewModel)
    }
    
    func updateETAs(query: CtbNwfbETAQuery?, bound: String, data: [CtbNwfbETAResponse.CtbNwfbETAData]){
        var etas = [String]()
        var company: BusCompany = .none
        guard let query = query else {return}
        for eta in data{
            if (eta.co == BusCompany.CTB.rawValue){
                company = .CTB
                if (eta.route == query.routeNum && eta.dir == bound){
                    if let display = KmbManager.getETA(raw: eta.eta){
                        etas.append(display)
                    }
                }
            }else if (eta.co == BusCompany.NWFB.rawValue){
                company = .NWFB
                if (eta.route == query.routeNum && eta.dir == bound){
                    if let display = KmbManager.getETA(raw: eta.eta){
                        etas.append(display)
                    }
                }
            }
        }
        if (etas.count == 0){return}
        let eta1: String? = (etas.count >= 1) ? etas[0] : nil
        let eta2: String? = (etas.count >= 2) ? etas[1] : nil
        let eta3: String? = (etas.count >= 3) ? etas[2] : nil
        let route = RouteMetadata(query.routeNum, bound, "")
        let etaItem = MainPage.ETAItem(route: route, stopId: query.stopId, company: company, eta1: eta1, eta2: eta2, eta3: eta3)
        if let index = self.etaViewModel.etaList.firstIndex(where: {$0.stopId == query.stopId && $0.route == route && $0.company == company}){
            self.etaViewModel.etaList[index] = etaItem
        }else{
            self.etaViewModel.etaList.append(etaItem)
        }
        self.viewController?.updateETAs(etaList: self.etaViewModel)
    }
    
    func updateETAs(query: NlbETAQuery?, bound: String, data: [NlbETAResponse.NlbETAData]){
        var etas = [String]()
        guard let query = query else {return}
        for eta in data{
            if let display = KmbManager.getETA(raw: eta.estimatedArrivalTime, format: "yyyy-MM-dd HH:mm:ss"){
                etas.append(display)
            }
        }
        if (etas.count == 0){return}
        let eta1: String? = (etas.count >= 1) ? etas[0] : nil
        let eta2: String? = (etas.count >= 2) ? etas[1] : nil
        let eta3: String? = (etas.count >= 3) ? etas[2] : nil
        let route = RouteMetadata(query.routeNum, bound, "", routeId: query.routeId)
        let etaItem = MainPage.ETAItem(route: route, stopId: query.stopId, company: .NLB, eta1: eta1, eta2: eta2, eta3: eta3)
        if let index = self.etaViewModel.etaList.firstIndex(where: {$0.stopId == query.stopId && $0.route == route && $0.company == .NLB}){
            self.etaViewModel.etaList[index] = etaItem
        }else{
            self.etaViewModel.etaList.append(etaItem)
        }
        self.viewController?.updateETAs(etaList: self.etaViewModel)
    }
}
