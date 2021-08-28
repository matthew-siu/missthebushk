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
        return .Bookmarks
    }
    
    func loadAllBookmarksOfRoute(){
        if let bookmarks = StopBookmarkManager.getStopBookmarks(){
            self.bookmarks = bookmarks
            print("loadAllBookmarksOfRoute \(bookmarks.count)")
            self.startETATimer()
            self.presenter?.displayBookmarks(bookmarks: bookmarks)
        }else{
            self.presenter?.displayBookmarks(bookmarks: [])
        }
    }
    
    func loadAllRemindersOfRoute(){
        if let reminders = StopReminderManager.getStopReminders(){
            self.reminders = reminders
            print("loadAllRemindersOfRoute \(reminders.count)")
            self.presenter?.displayReminders(reminders: reminders)
        }else{
            self.presenter?.displayReminders(reminders: [])
        }
    }
    
    func loadOneUpcomingReminder(){
        self.presenter?.displayUpcoming(reminder: nil)
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
        print("getStopReminder: nil")
        return nil
    }
}

// MARK: - Logic
extension MainPageInteractor {
    private func startETATimer(){
        self.dismissETATimer()
        
        self.requestETA(nil)
        self.etaTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(requestETA), userInfo: nil, repeats: true)
    }
    @objc
    private func requestETA(_ timer: Timer?)
    {
        for bookmark in bookmarks{
            let query = KmbETAQuery(stopId: bookmark.stopId, route: bookmark.routeNum, serviceType: bookmark.serviceType)
            self.requestOneStopETA(query: query, bound: bookmark.bound)
        }
    }
    
    private func requestOneStopETA(query: KmbETAQuery, bound: String){
        DispatchQueue.main.async {
            
            KmbManager.requestOneKmbStopETA(query: query)
                .done{response in
                    if let response = response as? KmbETAResponse, let resp = response.data{
                        self.presenter?.updateETAs(query: query, bound: bound, data: resp)
                    }
                }
                .catch{err in
                    print("fail")
                }
        }
    }
}
