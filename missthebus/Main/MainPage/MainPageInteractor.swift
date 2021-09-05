//
//  MainPageInteractor.swift
//  missthebus
//
//  Created by Matthew Siu on 6/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

// MARK: - Requests from view
protocol MainPageBusinessLogic
{
    func loadFirstTab() -> MainPage.Tab
    func loadAllBookmarksOfRoute()
    func loadAllRemindersOfRoute()
    func loadOneUpcomingReminder()
    func dismissETATimer()
    func changeToTab(at index: Int)
    func removeBookmark(at index: Int)
    func rearrangeBookmark(at pos1: Int, to pos2: Int)
    func removeReminder(at index: Int)
    func rearrangeReminder(at pos1: Int, to pos2: Int)
}

// MARK: - Datas retain in interactor defines here
protocol MainPageDataStore
{
    func getStopBookmark(route: RouteMetadata, stopId: String) -> StopBookmark?
    func getStopReminder(index: Int) -> StopReminder?
}

// MARK: - Interactor Body
class MainPageInteractor: MainPageBusinessLogic, MainPageDataStore
{
    
    
    // VIP Properties
    var presenter: MainPagePresentationLogic?
    var worker: MainPageWorker?
    
    // State
    var upcomingReminder: MainPage.DisplayItem.UpcomingReminders.ViewModel?
    var reminders: [StopReminder] = []
    var bookmarks: [StopBookmark] = []
    var etaTimer: Timer?
    
    init(request: MainPageBuilder.BuildRequest) {
        
    }
}

// MARK: - Business
extension MainPageInteractor {
    
    func loadFirstTab() -> MainPage.Tab{
        /* TODO:
            1. If have upcoming reminder, -> upcoming
            2. Else, -> bookmarks
         */
        return .Upcoming
    }
    
    func dismissETATimer(){
        print("dismiss ETA time")
        self.etaTimer?.invalidate()
        self.etaTimer = nil
    }
    
    func changeToTab(at index: Int){
        if (index == MainPage.Tab.Bookmarks.rawValue){
            self.dismissETATimer()
            self.loadAllBookmarksOfRoute()
        }else if (index == MainPage.Tab.Reminders.rawValue){
            self.dismissETATimer()
            self.loadAllRemindersOfRoute()
        }else if (index == MainPage.Tab.Upcoming.rawValue){
            self.dismissETATimer()
            self.loadOneUpcomingReminder()
        }
    }
}

// MARK: - Upcoming
extension MainPageInteractor{
    
    func loadOneUpcomingReminder(){
        Log.d(.RUNTIME, "loadOneUpcomingReminder")
        self.presenter?.displayUpcoming(viewModel: MainPage.DisplayItem.UpcomingReminders.ViewModel(upcomingReminder: nil))
        self.getUpcomingStopReminder()
            .then{upcoming in self.createUpcomingViewModel(reminder: upcoming)}
            .done{viewModel in
                self.upcomingReminder = viewModel
                self.presenter?.displayUpcoming(viewModel: viewModel)
                self.startETATimer(tab: .Upcoming)
            }.catch{_ in }
    }
    
    func createUpcomingViewModel(reminder: StopReminder?) -> Promise<MainPage.DisplayItem.UpcomingReminders.ViewModel>{
        return Promise {promise in
            
            if let reminder = reminder{
                var routes = [MainPage.UpcomingReminderItem.ReminderRouteItem]()
                for route in reminder.routes{
                    Log.d(.RUNTIME, "presenter: appending route \(route.routeNum)")
                    if let oneRoute = route.getRoute(){
                        var stops = [MainPage.UpcomingReminderItem.ReminderRouteStopItem]()
                        for routeStop in route.getStops(){
                            stops.append(MainPage.UpcomingReminderItem.ReminderRouteStopItem(stop: routeStop?.stop?.name ?? "", stopId: routeStop?.stopId ?? ""))
                        }
                        routes.append(MainPage.UpcomingReminderItem.ReminderRouteItem(company: oneRoute.company, route: RouteMetadata(route.routeNum, route.bound, route.serviceType, routeId: route.routeId), destStop: oneRoute.destStop, stops: stops))
                    }
                }
                let reminderItem = MainPage.UpcomingReminderItem(header: MainPage.UpcomingReminderItem.UpcomingHeader(id: reminder.id, name: reminder.name ?? "", period: reminder.displayPeriod, startTime: reminder.startTime, type: reminder.type ?? .OTHER), routes: routes)
                let viewModel = MainPage.DisplayItem.UpcomingReminders.ViewModel(upcomingReminder: reminderItem)
                promise.fulfill(viewModel)
            }else{
                let viewModel = MainPage.DisplayItem.UpcomingReminders.ViewModel(upcomingReminder: nil)
                promise.fulfill(viewModel)
            }
        }
    }
    
    @objc
    private func requestUpcomingETA(_ timer: Timer?){
        if let upcoming = self.upcomingReminder?.upcomingReminder?.routes{
            for route in upcoming{
                for stop in route.stops {
                    let query = self.createUpcomingETAQuery(route: route, stop: stop)
                    if let query = query{
                        self.requestOneStopETA(query: query, bound: route.route.bound)
                    }
                }
            }
        }
    }
    
    private func createUpcomingETAQuery(route: MainPage.UpcomingReminderItem.ReminderRouteItem, stop: MainPage.UpcomingReminderItem.ReminderRouteStopItem) -> APIQuery?{
        var query: APIQuery?
        if (route.company == .KMB){
            query = KmbETAQuery(stopId: stop.stopId, route: route.route.routeNum, serviceType: route.route.serviceType)
        }else if (route.company == .CTB){
            query = CtbNwfbETAQuery(company: .CTB, stopId: stop.stopId, routeNum: route.route.routeNum)
        }else if (route.company == .NWFB){
            query = CtbNwfbETAQuery(company: .NWFB, stopId: stop.stopId, routeNum: route.route.routeNum)
        }else if (route.company == .NLB){
            query = NlbETAQuery(routeId: route.route.routeId, routeNum: route.route.routeNum, stopId: stop.stopId)
        }
        return query
    }

    private func getUpcomingStopReminder() -> Promise<StopReminder?>{
        return Promise { promise in
            promise.fulfill(StopReminderManager.getUpcomingStopReminder())
        }
    }
    
}

// MARK: - Bookmark
extension MainPageInteractor{
    
    func loadAllBookmarksOfRoute(){
        self.presenter?.displayBookmarks(bookmarks: [])
        self.getStopBookmarks()
            .done{bookmarks in
                self.bookmarks = bookmarks
                self.presenter?.displayBookmarks(bookmarks: bookmarks)
                self.startETATimer(tab: .Bookmarks)
            }.catch{_ in}
    }
    
    private func getStopBookmarks() -> Promise<[StopBookmark]>{
        return Promise { promise in
            if let bookmarks = StopBookmarkManager.getStopBookmarks(){
                promise.fulfill(bookmarks)
            }else{
                promise.fulfill([])
            }
        }
    }
    
    @objc
    private func requestBookmarkETA(_ timer: Timer?){
        for bookmark in self.bookmarks{
            let query = self.createBookmarkETAQuery(bookmark: bookmark)
            if let query = query{
                self.requestOneStopETA(query: query, bound: bookmark.bound)
            }
        }
    }
    
    private func createBookmarkETAQuery(bookmark: StopBookmark) -> APIQuery?{
        var query: APIQuery?
        if (bookmark.company == .KMB){
            query = KmbETAQuery(stopId: bookmark.stopId, route: bookmark.routeNum, serviceType: bookmark.serviceType)
        }else if (bookmark.company == .CTB){
            query = CtbNwfbETAQuery(company: .CTB, stopId: bookmark.stopId, routeNum: bookmark.routeNum)
        }else if (bookmark.company == .NWFB){
            query = CtbNwfbETAQuery(company: .NWFB, stopId: bookmark.stopId, routeNum: bookmark.routeNum)
        }else if (bookmark.company == .NLB){
            query = NlbETAQuery(routeId: bookmark.routeId, routeNum: bookmark.routeNum, stopId: bookmark.stopId)
        }
        return query
    }
    
    func removeBookmark(at index: Int){
        let id = self.bookmarks[index].id
        self.bookmarks.remove(at: index)
        StopBookmarkManager.removeStopBookmark(id)
    }
    
    func rearrangeBookmark(at pos1: Int, to pos2: Int){
        if (pos1 != pos2){
            let mover = self.bookmarks.remove(at: pos1)
            self.bookmarks.insert(mover, at: pos2)
            StopBookmarkManager.rearrangeStopBookmark(at: pos1, to: pos2)
        }
    }
}


// MARK: - Reminder
extension MainPageInteractor{
    
    func loadAllRemindersOfRoute(){
        print("loadAllRemindersOfRoute")
        self.presenter?.displayReminders(reminders: [])
        self.getStopReminders()
            .done{reminders in
                self.reminders = reminders
                self.presenter?.displayReminders(reminders: reminders)
            }.catch{_ in}
    }
    
    private func getStopReminders() -> Promise<[StopReminder]>{
        return Promise {promise in
            if let reminders = StopReminderManager.getStopReminders(){
                print("reminders: \(reminders.count)")
                promise.fulfill(reminders)
            }else{
                print("reminders: nil")
                promise.fulfill([])
            }
        }
    }
    
    func removeReminder(at index: Int) {
        print("remove \(index)/\(self.reminders.count)")
        let id = self.reminders[index].id
        self.reminders.remove(at: index)
        StopReminderManager.removeStopReminder(id)
    }
    
    func rearrangeReminder(at pos1: Int, to pos2: Int) {
        if (pos1 != pos2){
            let mover = self.reminders.remove(at: pos1)
            self.reminders.insert(mover, at: pos2)
            StopReminderManager.rearrangeStopReminder(at: pos1, to: pos2)
        }
    }
}


// MARK: - MainPageDataStore
extension MainPageInteractor{
    
    func getStopBookmark(route: RouteMetadata, stopId: String) -> StopBookmark?{
        return self.bookmarks.first(where: {$0.stopId == stopId && $0.routeMetadata == route})
    }
    
    func getStopReminder(index: Int) -> StopReminder?{
        if (self.reminders.count >= index){
            return self.reminders[index]
        }
        return nil
    }
}

// MARK: - ETA Timer
extension MainPageInteractor {
    private func startETATimer(tab: MainPage.Tab){
        self.dismissETATimer()
        
        if (tab == .Bookmarks){
            self.requestBookmarkETA(nil)
            self.etaTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(requestBookmarkETA), userInfo: nil, repeats: true)
        }else if (tab == .Upcoming){
            self.requestUpcomingETA(nil)
            self.etaTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(requestUpcomingETA), userInfo: nil, repeats: true)
        }
        
    }
    
    private func requestOneStopETA(query: APIQuery, bound: String){
        DispatchQueue.main.async {
            
            KmbManager.requestOneStopETA(query: query)
                .done{response in
                    if let response = response as? KmbETAResponse, let resp = response.data{
                        self.presenter?.updateETAs(query: query as? KmbETAQuery, bound: bound, data: resp)
                    }else if let response = response as? CtbNwfbETAResponse, let resp = response.data{
                        self.presenter?.updateETAs(query: query as? CtbNwfbETAQuery, bound: bound, data: resp)
                    }else if let response = response as? NlbETAResponse, let resp = response.estimatedArrivals{
                        self.presenter?.updateETAs(query: query as? NlbETAQuery, bound: bound, data: resp)
                    }
                }
                .catch{err in
                    print("fail")
                }
        }
    }
}
