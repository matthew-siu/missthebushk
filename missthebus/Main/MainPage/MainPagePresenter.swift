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
    func displayBookmarks(reminders: [StopReminder])
    func updateETAs(query: KmbETAQuery, bound: String, data: [KmbETAResponse.KmbETAData])
}

// MARK: - Presenter main body
class MainPagePresenter: MainPagePresentationLogic
{
    weak var viewController: MainPageDisplayLogic?
    
    var reminders = [StopReminder]()
    var etaViewModel = MainPage.DisplayItem.ETAViewModel()
}

// MARK: - Presentation receiver
extension MainPagePresenter {
    
    func displayBookmarks(reminders: [StopReminder]){
        self.reminders = reminders
        let bookMarkItems = reminders.enumerated().map{(index, reminder) in
            return MainPage.BookmarkItem(index: index, stopId: reminder.stopId, routeNum: reminder.routeNum, bound: reminder.bound, serviceType: reminder.serviceType, company: reminder.company, destStop: reminder.destStop ?? "", currentStop: reminder.currentStop ?? "")
        }
        self.viewController?.displayReminders(reminders: bookMarkItems)
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
