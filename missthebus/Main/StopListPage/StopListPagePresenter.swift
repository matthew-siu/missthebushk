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
    
    func displayInitialNormalState(route: Route, stopList: [Stop], bookmarks: [StopBookmark], selectedStopId: String?)
    
    func displayInitialGetRouteStopState(route: Route, stopList: [Stop], bookmarks: [StopBookmark], selectedStopSeq: [Int])
    
    func displayETA(data: [KmbETAResponse.KmbETAData]?)
    
    func displayETA(data: [CtbNwfbETAResponse.CtbNwfbETAData]?)
    
    func displayETA(query: APIQuery, data: [NlbETAResponse.NlbETAData]?)
}

// MARK: - Presenter main body
class StopListPagePresenter: StopListPagePresentationLogic
{
    
    weak var viewController: StopListPageDisplayLogic?
    
    var route: Route?
    var stopList: [Stop]?
}

// MARK: - Presentation receiver
extension StopListPagePresenter {
    
    
    func displayInitialNormalState(route: Route, stopList: [Stop], bookmarks: [StopBookmark], selectedStopId: String?) {
        self.route = route
        self.stopList = stopList
        self.viewController?.displayInitialNormalState(route: route, stopList: stopList, bookmarks: bookmarks, selectedStopId: selectedStopId)
    }
    
    func displayInitialGetRouteStopState(route: Route, stopList: [Stop], bookmarks: [StopBookmark], selectedStopSeq: [Int]) {
        self.route = route
        self.stopList = stopList
        self.viewController?.displayInitialGetRouteStopState(route: route, stopList: stopList, bookmarks: bookmarks, selectedStopSeq: selectedStopSeq)
    }
    
    func displayETA(data: [KmbETAResponse.KmbETAData]?){
        if let data = data, let route = self.route {
            var etaList: [StopListPage.ETA] = []
            print("ETA count: \(data.count)")
            for eta in data{
                if (eta.route == route.route && eta.dir == route.bound && String(eta.service_type ?? -1) == route.serviceType){
                    if let display = KmbManager.getETA(raw: eta.eta){
                        
                        etaList.append(StopListPage.ETA(company: .KMB, seq: eta.seq ?? -1, display: display, remark: eta.rmk))
                    }
                }
            }
            let viewModel = StopListPage.DisplayItem.ETAViewModel(etaViews: etaList)
            self.viewController?.displayETAOnOneStop(etaList: viewModel)
        }
    }
    
    func displayETA(data: [CtbNwfbETAResponse.CtbNwfbETAData]?){
        if let data = data, let route = self.route {
            var etaList: [StopListPage.ETA] = []
            print("ETA count: \(data.count)")
            for (index, eta) in data.enumerated(){
                if (eta.co == BusCompany.CTB.rawValue){
                    if (eta.route == route.route && eta.dir == route.bound){
                        if let display = KmbManager.getETA(raw: eta.eta){
                            etaList.append(StopListPage.ETA(company: .CTB, seq: eta.seq ?? -1, display: display, remark: eta.rmk))
                        }
                    }
                }else if (eta.co == BusCompany.NWFB.rawValue){
                    if (eta.route == route.route && eta.dir == route.bound){
                        if let display = KmbManager.getETA(raw: eta.eta){
                            etaList.append(StopListPage.ETA(company: .NWFB, seq: eta.seq ?? -1, display: display, remark: eta.rmk))
                        }
                    }
                }
            }
            let viewModel = StopListPage.DisplayItem.ETAViewModel(etaViews: etaList)
            self.viewController?.displayETAOnOneStop(etaList: viewModel)
        }
    }
    
    func displayETA(query: APIQuery, data: [NlbETAResponse.NlbETAData]?){
        if let data = data, let _ = self.route, let query = query as? NlbETAQuery {
            var etaList: [StopListPage.ETA] = []
            print("ETA count: \(data.count)")
            for eta in data{
                
                if let display = KmbManager.getETA(raw: eta.estimatedArrivalTime, format: "yyyy-MM-dd HH:mm:ss"){
                    if let stop = self.route?.stopList.first(where: {$0.routeId == query.routeId && $0.stopId == query.stopId}){
                        etaList.append(StopListPage.ETA(company: .NLB, seq: stop.seq.integer ?? -1, display: display, remark: nil))
                    }
                }
            }
            let viewModel = StopListPage.DisplayItem.ETAViewModel(etaViews: etaList)
            self.viewController?.displayETAOnOneStop(etaList: viewModel)
        }
    }
}
