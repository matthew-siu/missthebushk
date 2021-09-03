//
//  KmbManager.swift
//  missthebus
//
//  Created by Matthew Siu on 21/7/2021.
//

import Foundation
import PromiseKit

class KmbManager{
    
    
    /* *********************************
     * APIs Call
     ******************************** */
    
    // 1. Get Routes API
    
    static func requestAllKmbRoutes() -> Promise<KmbRouteResponse?> {
        
        let repo = KmbRouteAPIRepository()
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in promise.fulfill(response.body ?? nil) }
                .catch { (error) in promise.reject(error) }
        }
    }
    
    static func requestAllCtbRoutes() -> Promise<CtbNwfbRouteResponse?> {
        
        let repo = CtbNwfbRouteAPIRepository(company: .CTB)
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in promise.fulfill(response.body ?? nil) }
                .catch { (error) in promise.reject(error) }
        }
    }
    
    static func requestAllNwfbRoutes() -> Promise<CtbNwfbRouteResponse?> {
        
        let repo = CtbNwfbRouteAPIRepository(company: .NWFB)
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in promise.fulfill(response.body ?? nil)}
                .catch { (error) in promise.reject(error) }
        }
    }
    
    static func requestAllNlbRoutes() -> Promise<NlbRouteResponse?> {
        
        let repo = NlbRouteAPIRepository()
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in promise.fulfill(response.body ?? nil)}
                .catch { (error) in promise.reject(error) }
        }
    }
    
    // 2. Get Stops API
    
    static func requestAllKmbStops() -> Promise<KmbStopResponse?> {
        
        let repo = KmbStopAPIRepository()
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in promise.fulfill(response.body ?? nil) }
                .catch { (error) in promise.reject(error) }
        }
    }
    
    static func requestCtbNwfbStop(stopId: String) -> Promise<CtbNwfbStopResponse?>{
        let repo = CtbNwfbStopAPIRepository(stopId: stopId)
        return Promise { promise in
            KMBAPI.send(repository: repo)
                .done { (response) in promise.fulfill(response.body ?? nil) }
                .catch { (error) in promise.reject(error) }
        }
    }
    
    // 3. Get Route Stops API
    
    static func requestAllKmbRouteStops() -> Promise<KmbRouteStopResponse?> {
        
        let repo = KmbRouteStopAPIRepository()
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in promise.fulfill(response.body ?? nil) }
                .catch { (error) in promise.reject(error) }
        }
    }
    
    static func requestAllCtbNwfbRouteStops(busCompany: BusCompany, routeNum: String, bound: String) -> Promise<CtbNwfbRouteStopResponse?> {
        // use promise.all to call inbound and outbound
        let repo = CtbNwfbRouteStopAPIRepository(
            company: (busCompany == .CTB) ? .CTB : .NWFB,
            routeNum: routeNum,
            bound: (bound == "I") ? .Inbound : .Outbound)
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in promise.fulfill(response.body ?? nil) }
                .catch { (error) in promise.reject(error) }
        }
    }
    
    static func requestAllNlbRouteStops(routeId: String) -> Promise<NlbRouteStopResponse?> {
        
        let repo = NlbRouteStopAPIRepository(routeId: routeId)
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in promise.fulfill(response.body ?? nil) }
                .catch { (error) in promise.reject(error) }
        }
    }
    
    // 4. Get Stop ETA
    static func requestOneStopETA(query: APIQuery) -> Promise<APIResponse?>{
        
        if let query = query as? KmbETAQuery {
            print("requestOneStopETA: KmbETAQuery")
            return self.requestOneKmbStopETA(query: query)
        }else if let query = query as? CtbNwfbETAQuery {
            print("requestOneStopETA: CtbNwfbETAQuery")
            return self.requestOneCtbNwfbStopETA(query: query)
        }else if let query = query as? NlbETAQuery {
            print("requestOneStopETA: NlbETAQuery")
            return self.requestOneNlbStopETA(query: query)
        }else{
            print("requestOneStopETA: reject")
            return Promise{promise in promise.fulfill(nil)}
        }
    }
    
    static func requestOneKmbStopETA(query: KmbETAQuery) -> Promise<APIResponse?> {
        
        let repo = KmbETAAPIRepository(query: query)
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in promise.fulfill(response.body ?? nil) }
                .catch { (error) in promise.reject(error) }
        }
    }
    
    static func requestOneCtbNwfbStopETA(query: CtbNwfbETAQuery) -> Promise<APIResponse?> {
        
        let repo = CtbNwfbETAAPIRepository(query: query)
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in promise.fulfill(response.body ?? nil) }
                .catch { (error) in promise.reject(error) }
        }
    }
    
    static func requestOneNlbStopETA(query: NlbETAQuery) -> Promise<APIResponse?> {
        
        let repo = NlbETAAPIRepository(query: query)
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in promise.fulfill(response.body ?? nil) }
                .catch { (error) in promise.reject(error) }
        }
    }
    
    
    /* *********************************
     * Storage method
     ******************************** */
    
    // Storage: Routes
    
    static func saveAllRoutes(_ routes: [Route]){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(routes)
            Storage.save(Configs.Storage.KEY_ROUTES, data)
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    static func getAllRoutes() -> [Route]?{
        if let data = Storage.getObject(Configs.Storage.KEY_ROUTES){
            do {
                let decoder = JSONDecoder()
                let routes = try decoder.decode([Route].self, from: data)
                return routes

            } catch {
                print("Unable to Decode Notes (\(error))")
                return nil
            }
        }
        return nil
    }
    
    // Storage: Stops
    
    static func saveAllStops(_ stops: [Stop]){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(stops)
            Storage.save(Configs.Storage.KEY_STOPS, data)
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    static func getAllStops() -> [Stop]?{
        if let data = Storage.getObject(Configs.Storage.KEY_STOPS){
            do {
                let decoder = JSONDecoder()
                let stops = try decoder.decode([Stop].self, from: data)
                return stops

            } catch {
                print("Unable to Decode Notes (\(error))")
                return nil
            }
        }
        return nil
    }
    
    // Storage: RouteStop
    
    static func saveAllRouteStops(_ stops: [RouteStop]){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(stops)
            Storage.save(Configs.Storage.KEY_ROUTESTOPS, data)
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    static func getAllRouteStops() -> [RouteStop]?{
        if let data = Storage.getObject(Configs.Storage.KEY_ROUTESTOPS){
            do {
                let decoder = JSONDecoder()
                let stops = try decoder.decode([RouteStop].self, from: data)
                return stops

            } catch {
                print("Unable to Decode Notes (\(error))")
                return nil
            }
        }
        return nil
    }
}

// search method

extension KmbManager{
    static func getRoute(route: String, bound: String, serviceType: String) -> Route?{
        return getAllRoutes()?.first(where: {$0.route == route && $0.bound == bound && $0.serviceType == serviceType})
    }
    
    static func getStop(stopId: String) -> Stop?{
        return getAllStops()?.first(where: { $0.stopId == stopId})
    }
    
    static func getStopBySeq(route: Route?, seq: String) -> Stop?{
        if let route = route, let stopId = getRoute(route: route.route, bound: route.bound, serviceType: route.serviceType)?.stopList.first(where: {$0.seq == seq})?.stopId{
            return getStop(stopId: stopId)
        }else{
            return nil
        }
    }
}

// algorithms

extension KmbManager{
    static func getETA(raw: String?, format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> String?{
        var display: String? = nil
        if let etaTime = raw, etaTime != ""{
            if let etaDate = Utils.convert2Date(time: etaTime, pattern: format){
                let nowDate = Date()
                let diff = Calendar.current.dateComponents([.minute, .second], from: nowDate, to: etaDate)
                if let diffMin = diff.minute, let _ = diff.second{
//                    print("\(nowDate) | \(etaDate) | diff: \(diffMin)mins \(diffSec)sec")
                    display = (diffMin > 0) ? String(diffMin) : "0"
                }
            }
            return display
        }else{
            return nil
        }
    }
}
