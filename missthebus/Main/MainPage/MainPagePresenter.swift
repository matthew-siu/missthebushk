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
    func updateETAs(query: KmbETAQuery, bound: String, data: [KmbETAResponse.KmbETAData])
}

// MARK: - Presenter main body
class MainPagePresenter: MainPagePresentationLogic
{
    weak var viewController: MainPageDisplayLogic?
    
    var reminders = [StopReminder]()
    var bookmarks = [StopBookmark]()
    var etaViewModel = MainPage.DisplayItem.ETAViewModel()
}

// MARK: - Presentation receiver
extension MainPagePresenter {
    
    func displayBookmarks(bookmarks: [StopBookmark]){
        self.bookmarks = bookmarks
        let bookMarkItems = bookmarks.enumerated().map{(index, bookmark) in
            return MainPage.BookmarkItem(index: index, stopId: bookmark.stopId, routeNum: bookmark.routeNum, bound: bookmark.bound, serviceType: bookmark.serviceType, company: bookmark.company, destStop: bookmark.destStop ?? "", currentStop: bookmark.currentStop ?? "")
        }
        self.viewController?.displayBookmarks(reminders: bookMarkItems)
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
        let etaItem = MainPage.ETAItem(stopId: query.stopId, eta1: eta1, eta2: eta2, eta3: eta3)
        if let index = self.etaViewModel.etaList.firstIndex(where: {$0.stopId == query.stopId}){
            self.etaViewModel.etaList[index] = etaItem
        }else{
            self.etaViewModel.etaList.append(etaItem)
        }
        self.viewController?.updateETAs(etaList: self.etaViewModel)
    }
}
