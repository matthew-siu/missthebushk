//
//  StopListPagePresenter.swift
//  missthebus
//
//  Created by Matthew Siu on 20/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Presentation logic goes here
protocol StopListPagePresentationLogic
{
//    func displayInitialState(route: KmbRoute, stopList: [KmbStop], bookmarks: [StopBookmark], selectedStopId: String?, requestType: StopListPage.RequestType?, selectedStopSeqList: [Int])
    
    func displayInitialNormalState(route: KmbRoute, stopList: [KmbStop], bookmarks: [StopBookmark], selectedStopId: String?)
    
    func displayInitialGetRouteStopState(route: KmbRoute, stopList: [KmbStop], bookmarks: [StopBookmark], selectedStopSeq: [Int])
    
    func displayETA(data: [KmbETAResponse.KmbETAData]?)
}

// MARK: - Presenter main body
class StopListPagePresenter: StopListPagePresentationLogic
{
    
    weak var viewController: StopListPageDisplayLogic?
    
    var route: KmbRoute?
    var stopList: [KmbStop]?
}

// MARK: - Presentation receiver
extension StopListPagePresenter {
    
    
    func displayInitialNormalState(route: KmbRoute, stopList: [KmbStop], bookmarks: [StopBookmark], selectedStopId: String?) {
        self.route = route
        self.stopList = stopList
        self.viewController?.displayInitialNormalState(route: route, stopList: stopList, bookmarks: bookmarks, selectedStopId: selectedStopId)
    }
    
    func displayInitialGetRouteStopState(route: KmbRoute, stopList: [KmbStop], bookmarks: [StopBookmark], selectedStopSeq: [Int]) {
        self.route = route
        self.stopList = stopList
        self.viewController?.displayInitialGetRouteStopState(route: route, stopList: stopList, bookmarks: bookmarks, selectedStopSeq: selectedStopSeq)
    }
    
    func displayETA(data: [KmbETAResponse.KmbETAData]?){
        if let data = data, let route = self.route {
            var etaList: [StopListPage.ETA] = []
            print("ETA count: \(data.count)")
            for eta in data{
                if (eta.co == BusCompany.KMB.rawValue){
                    if (eta.route == route.route && eta.dir == route.bound && String(eta.service_type ?? -1) == route.serviceType){
                        var display = ""
                        if let etaTime = eta.eta{
                            let etaDate = Utils.convert2Date(time: etaTime, pattern: "yyyy-MM-dd'T'HH:mm:ssZ")
                            let nowDate = Date()
                            let diff = Calendar.current.dateComponents([.minute, .second], from: nowDate, to: etaDate)
                            if let diffMin = diff.minute, let diffSec = diff.second{
                                print("\(nowDate) | \(etaDate) | diff: \(diffMin)mins \(diffSec)sec")
//                                display = (diffMin == 0) ? String(diffMin) : "-"

                                display = (diffMin > 0) ? String(diffMin) : "0"
                            }
                        }
                        etaList.append(StopListPage.ETA(company: .KMB, seq: eta.seq ?? -1, display: display, remark: eta.rmk))
                    }
                }
            }
            let viewModel = StopListPage.DisplayItem.ETAViewModel(etaViews: etaList)
            self.viewController?.displayETAOnOneStop(etaList: viewModel)
        }
    }
}
