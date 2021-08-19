//
//  StopBookmarkManager.swift
//  missthebus
//
//  Created by Matthew Siu on 5/8/2021.
//

import Foundation

class StopBookmarkManager{
    
    // get bookmarked stop of one single route
    static func getBookmarksFromRoute(route: String, bound: String, serviceType: String) -> [StopBookmark]?{
        return self.getStopBookmarks()?.filter({$0.routeNum == route && $0.bound == bound && $0.serviceType == serviceType})
    }
    
    static func getOneBookmarkFromRoute(stopId: String, route: String, bound: String, serviceType: String) -> StopBookmark?{
        return self.getStopBookmarks()?.first(where: {$0.stopId == stopId && $0.routeNum == route && $0.bound == bound && $0.serviceType == serviceType})
    }
}

extension StopBookmarkManager{
    
    static func getStopBookmarks() -> [StopBookmark]?{
        if let data = Storage.getObject(Configs.Storage.KEY_BOOKMARKS){
            do {
                let decoder = JSONDecoder()
                let stops = try decoder.decode([StopBookmark].self, from: data)
                return stops

            } catch {
                print("Unable to Decode Notes (\(error))")
                return nil
            }
        }
        return nil
    }
    
    static func saveStopBookmarks(_ bookmarks: [StopBookmark]){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(bookmarks)
            Storage.save(Configs.Storage.KEY_BOOKMARKS, data)
        } catch {
            print("StopBookmarks: Unable to Encode Note (\(error))")
        }
    }
    
    static func addStopBookmark(_ bookmark: StopBookmark){
        self.removeStopBookmark(bookmark.id) // remove bookmarkId
        if var bookmarks = self.getStopBookmarks(){
            bookmarks.append(bookmark)
            self.saveStopBookmarks(bookmarks)
        }else{
            self.saveStopBookmarks([bookmark])
        }
    }
    
    static func removeStopBookmark(_ bookmarkId: String){
        if var bookmarks = self.getStopBookmarks(){
            bookmarks.removeAll(where: {$0.id == bookmarkId})
            self.saveStopBookmarks(bookmarks)
        }
    }
    
    static func updateStopBookmark(_ bookmark: StopBookmark){
        self.removeStopBookmark(bookmark.id)
        self.addStopBookmark(bookmark)
    }
    
    static func rearrangeStopBookmark(at pos1: Int, to pos2: Int){
        if var bookmarks = self.getStopBookmarks(){
            let mover = bookmarks.remove(at: pos1)
            bookmarks.insert(mover, at: pos2)
            self.saveStopBookmarks(bookmarks)
        }
    }
}
