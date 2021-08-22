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
    
    static func requestAllRoutes() -> Promise<KmbRouteResponse?> {
        
        let repo = KmbRouteAPIRepository()
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in
                    if let ref = response.body  {
                        promise.fulfill(ref)
                    } else {
                        promise.fulfill(nil)
                    }
                }
                .catch { (error) in
                    promise.reject(error)
            }
        }
    }
    
    static func requestAllStops() -> Promise<KmbStopResponse?> {
        
        let repo = KmbStopAPIRepository()
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in
                    if let ref = response.body  {
                        promise.fulfill(ref)
                    } else {
                        promise.fulfill(nil)
                    }
                }
                .catch { (error) in
                    promise.reject(error)
            }
        }
    }
    
    static func requestAllRouteStops() -> Promise<KmbRouteStopResponse?> {
        
        let repo = KmbRouteStopAPIRepository()
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in
                    if let ref = response.body  {
                        promise.fulfill(ref)
                    } else {
                        promise.fulfill(nil)
                    }
                }
                .catch { (error) in
                    promise.reject(error)
            }
        }
    }
    
    static func requestOneStopETA(query: KmbETAQuery) -> Promise<KmbETAResponse?> {
        
        let repo = KmbETAAPIRepository(query: query)
        return Promise{ promise in
            KMBAPI.send(repository: repo)
                .done { (response) in
                    if let ref = response.body  {
                        promise.fulfill(ref)
                    } else {
                        promise.fulfill(nil)
                    }
                }
                .catch { (error) in
                    promise.reject(error)
            }
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
    
    static func saveAllStops(_ stops: [KmbStop]){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(stops)
            Storage.save(Configs.Storage.KEY_STOPS, data)
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    static func getAllStops() -> [KmbStop]?{
        if let data = Storage.getObject(Configs.Storage.KEY_STOPS){
            do {
                let decoder = JSONDecoder()
                let stops = try decoder.decode([KmbStop].self, from: data)
                return stops

            } catch {
                print("Unable to Decode Notes (\(error))")
                return nil
            }
        }
        return nil
    }
    
    // Storage: RouteStop
    
    static func saveAllRouteStops(_ stops: [KmbRouteStop]){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(stops)
            Storage.save(Configs.Storage.KEY_ROUTESTOPS, data)
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    static func getAllRouteStops() -> [KmbRouteStop]?{
        if let data = Storage.getObject(Configs.Storage.KEY_ROUTESTOPS){
            do {
                let decoder = JSONDecoder()
                let stops = try decoder.decode([KmbRouteStop].self, from: data)
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
    
    static func getStop(stopId: String) -> KmbStop?{
        return getAllStops()?.first(where: { $0.stopId == stopId})
    }
    
    static func getStopBySeq(route: Route?, seq: String) -> KmbStop?{
        if let route = route, let stopId = getRoute(route: route.route, bound: route.bound, serviceType: route.serviceType)?.stopList.first(where: {$0.seq == seq})?.stopId{
            return getStop(stopId: stopId)
        }else{
            return nil
        }
    }
}

// algorithms

extension KmbManager{
    static func getETA(raw: String?) -> String{
        var display = ""
        if let etaTime = raw{
            let etaDate = Utils.convert2Date(time: etaTime, pattern: "yyyy-MM-dd'T'HH:mm:ssZ")
            let nowDate = Date()
            let diff = Calendar.current.dateComponents([.minute, .second], from: nowDate, to: etaDate)
            if let diffMin = diff.minute{
                display = (diffMin > 0) ? String(diffMin) : "0"
            }
        }
        return display
    }
}
