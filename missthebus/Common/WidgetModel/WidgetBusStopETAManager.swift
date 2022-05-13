//
//  WidgetBusStopETAManager.swift
//  missthebus
//
//  Created by Matthew Siu on 12/5/2022.
//

import Foundation
import PromiseKit

class WidgetBusStopETAManager{
    
    var bookmarks: [StopBookmark] = []
    
    init() {
    }
    
    func requestETA() -> Promise<[WidgetBusStopETA]>{
        return Promise { promise in
            self.bookmarks = self.getStopBookmarks() ?? []
            self.bookmarks = Array(self.bookmarks.prefix(4))
            print("requestETA: \(self.bookmarks.count)")
            var etaRequestList = [Promise<WidgetBusStopETA>]()
            for bookmark in self.bookmarks {
                if let query = self.createBookmarkETAQuery(bookmark: bookmark){
                    print("query: \(bookmark.routeNum) \(bookmark.currentStop)")
                    etaRequestList.append(self.requestOneStopETA(query: query, bound: bookmark.bound))
                }
            }
            when(fulfilled: etaRequestList)
                .done{responses in
//                    for (index, routeResp) in responses.enumerated(){
//
//                    }
                    
                    promise.fulfill(responses)
                }
                .catch{err in
                    promise.reject(err)
                }
        }
    }
    
    func getStopBookmarks() -> [StopBookmark]?{
        if let data = Storage.getObject(suiteName: Configs.SuiteName.AppGroup, Configs.Storage.KEY_BOOKMARKS){
            do {
                let decoder = JSONDecoder()
                let stops = try decoder.decode([StopBookmark].self, from: data)
                print("stops: \(stops.count)")
                return stops

            } catch {
                print("Unable to Decode Notes (\(error))")
                return nil
            }
        }
        print("stops: nil")
        return nil
    }
    
    
    private func createBookmarkETAQuery(bookmark: StopBookmark) -> APIQuery?{
        var query: APIQuery?
        if (bookmark.company == .KMB){
            query = KmbETAQuery(stopId: bookmark.stopId, route: bookmark.routeNum, serviceType: bookmark.serviceType, stopName: bookmark.currentStop)
        }else if (bookmark.company == .CTB){
            query = CtbNwfbETAQuery(company: .CTB, stopId: bookmark.stopId, routeNum: bookmark.routeNum, stopName: bookmark.currentStop)
        }else if (bookmark.company == .NWFB){
            query = CtbNwfbETAQuery(company: .NWFB, stopId: bookmark.stopId, routeNum: bookmark.routeNum, stopName: bookmark.currentStop)
        }else if (bookmark.company == .NLB){
            query = NlbETAQuery(routeId: bookmark.routeId, routeNum: bookmark.routeNum, stopId: bookmark.stopId, stopName: bookmark.currentStop)
        }
        return query
    }
    
    private func requestOneStopETA(query: APIQuery, bound: String) -> Promise<WidgetBusStopETA>{
        return Promise { promise in
            print("requestOneStopETA")
            BusManager.requestOneStopETA(query: query)
                .done{response in
                    if let response = response as? KmbETAResponse, let query = query as? KmbETAQuery, let resp = response.data{
                        let etaList = self.getETA(query: query, bound: bound, data: resp)
                        let eta = WidgetBusStopETA(id: UUID(), busNum: query.route, stopName: query.stopName ?? "", eta1: etaList[0], eta2: etaList[1])
                        promise.fulfill(eta)
                    }else if let response = response as? CtbNwfbETAResponse, let query = query as? KmbETAQuery, let resp = response.data{
                        
                    }else if let response = response as? NlbETAResponse, let query = query as? KmbETAQuery, let resp = response.estimatedArrivals{
                        
                    }
                }
                .catch{err in
                    promise.reject(err)
                }
            
        }

    }
}

extension WidgetBusStopETAManager{
    
    func getETA(query: KmbETAQuery?, bound: String, data: [KmbETAResponse.KmbETAData]) -> [String?]{
        var etas = [String]()
        guard let query = query else {return []}
        for eta in data{
            if (eta.route == query.route && eta.dir == bound && String(eta.service_type ?? -1) == query.serviceType){
                if let display = BusManager.getETA(raw: eta.eta){
                    etas.append(display)
                }
            }
        }
        let eta1: String? = (etas.count >= 1) ? etas[0] : nil
        let eta2: String? = (etas.count >= 2) ? etas[1] : nil
        return [eta1, eta2]
        
        
    }

//    func updateETAs(query: CtbNwfbETAQuery?, bound: String, data: [CtbNwfbETAResponse.CtbNwfbETAData]){
//        var etas = [String]()
//        var company: BusCompany = .none
//        guard let query = query else {return}
//        for eta in data{
//            if (eta.co == BusCompany.CTB.rawValue){
//                company = .CTB
//                if (eta.route == query.routeNum && eta.dir == bound){
//                    if let display = BusManager.getETA(raw: eta.eta){
//                        etas.append(display)
//                    }
//                }
//            }else if (eta.co == BusCompany.NWFB.rawValue){
//                company = .NWFB
//                if (eta.route == query.routeNum && eta.dir == bound){
//                    if let display = BusManager.getETA(raw: eta.eta){
//                        etas.append(display)
//                    }
//                }
//            }
//        }
//        if (etas.count == 0){return}
//        let eta1: String? = (etas.count >= 1) ? etas[0] : nil
//        let eta2: String? = (etas.count >= 2) ? etas[1] : nil
//        let eta3: String? = (etas.count >= 3) ? etas[2] : nil
//        let route = RouteMetadata(query.routeNum, bound, "")
//        let etaItem = MainPage.ETAItem(route: route, stopId: query.stopId, company: company, eta1: eta1, eta2: eta2, eta3: eta3)
//        if let index = self.etaViewModel.etaList.firstIndex(where: {$0.stopId == query.stopId && $0.route == route && $0.company == company}){
//            self.etaViewModel.etaList[index] = etaItem
//        }else{
//            self.etaViewModel.etaList.append(etaItem)
//        }
//        self.viewController?.updateETAs(etaList: self.etaViewModel)
//    }
//
//    func updateETAs(query: NlbETAQuery?, bound: String, data: [NlbETAResponse.NlbETAData]){
//        var etas = [String]()
//        guard let query = query else {return}
//        for eta in data{
//            if let display = BusManager.getETA(raw: eta.estimatedArrivalTime, format: "yyyy-MM-dd HH:mm:ss"){
//                etas.append(display)
//            }
//        }
//        if (etas.count == 0){return}
//        let eta1: String? = (etas.count >= 1) ? etas[0] : nil
//        let eta2: String? = (etas.count >= 2) ? etas[1] : nil
//        let eta3: String? = (etas.count >= 3) ? etas[2] : nil
//        let route = RouteMetadata(query.routeNum, bound, "", routeId: query.routeId)
//        let etaItem = MainPage.ETAItem(route: route, stopId: query.stopId, company: .NLB, eta1: eta1, eta2: eta2, eta3: eta3)
//        if let index = self.etaViewModel.etaList.firstIndex(where: {$0.stopId == query.stopId && $0.route == route && $0.company == .NLB}){
//            self.etaViewModel.etaList[index] = etaItem
//        }else{
//            self.etaViewModel.etaList.append(etaItem)
//        }
//        self.viewController?.updateETAs(etaList: self.etaViewModel)
//    }
//
}
