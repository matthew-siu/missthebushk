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
    func loadAllStopBookmarksOfRoute()
    func dismissETATimer()
}

// MARK: - Datas retain in interactor defines here
protocol MainPageDataStore
{
    func getStopBookmark(stopId: String) -> StopBookmark?
}

// MARK: - Interactor Body
class MainPageInteractor: MainPageBusinessLogic, MainPageDataStore
{
    // VIP Properties
    var presenter: MainPagePresentationLogic?
    var worker: MainPageWorker?
    
    // State
    var reminders: [StopReminder]?
    var bookmarks: [StopBookmark]?
    var etaTimer: Timer?
    
    init(request: MainPageBuilder.BuildRequest) {
        
    }
}
// MARK: - Business
extension MainPageInteractor {
    
    func getStopBookmark(stopId: String) -> StopBookmark?{
        return self.bookmarks?.first(where: {$0.stopId == stopId})
    }
    
    func loadAllStopBookmarksOfRoute(){
        if let bookmarks = StopBookmarkManager.getStopBookmarks(){
            self.bookmarks = bookmarks
            print("loadAllStopRemindersOfRoute \(bookmarks.count)")
            self.startETATimer()
            self.presenter?.displayBookmarks(bookmarks: bookmarks)
        }else{
            print("loadAllStopRemindersOfRoute nil")
        }
    }
    
    func dismissETATimer(){
        print("dismiss ETA time")
        self.etaTimer?.invalidate()
        self.etaTimer = nil
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
        if let bookmarks = self.bookmarks{
            for bookmark in bookmarks{
                let query = KmbETAQuery(stopId: bookmark.stopId, route: bookmark.routeNum, serviceType: bookmark.serviceType)
                self.requestOneStopETA(query: query, bound: bookmark.bound)
            }
        }
    }
    
    private func requestOneStopETA(query: KmbETAQuery, bound: String){
        DispatchQueue.main.async {
            
            KmbManager.requestOneStopETA(query: query)
                .done{response in
                    if let resp = response?.data{
                        self.presenter?.updateETAs(query: query, bound: bound, data: resp)
                    }
                }
                .catch{err in
                    print("fail")
                }
        }
    }
}
