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
    func displayInitialState(route: KmbRoute, stopList: [KmbStop])
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
    func displayInitialState(route: KmbRoute, stopList: [KmbStop]){
        self.route = route
        self.stopList = stopList
        self.viewController?.displayInitialState(route: route, stopList: stopList)
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
            let viewModel = StopListPage.DisplayItem.ViewModel(etaViews: etaList)
            self.viewController?.displayETAOnOneStop(etaList: viewModel)
        }
    }
}
