//
//  Storage.swift
//  Caine18RoadSDK
//
//  Created by Matthew Siu on 24/7/2019.
//  Copyright © 2019 ESD. All rights reserved.
//

import Foundation
import UIKit

class Storage{
    
    enum StorageType {
        case userDefaults
        case fileSystem
    }
    
    static func save(_ key: String, _ param: Any){
        UserDefaults.standard.set(param, forKey: key)
    }
    
    static func save(suiteName: String, _ key: String, _ param: Any){
        UserDefaults(suiteName: suiteName)?.set(param, forKey: key)
    }
    
    // save img
    static func save(img: UIImage,
                        forKey key: String,
                        withStorageType storageType: StorageType) {
        if let pngRepresentation = img.pngData() {
            switch storageType {
            case .fileSystem:
                if let filePath = filePath(forKey: key) {
                    do  {
                        try pngRepresentation.write(to: filePath,
                                                    options: .atomic)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
            case .userDefaults:
                UserDefaults.standard.set(pngRepresentation,
                                            forKey: key)
            }
        }
    }
    
    // get img
    static func retrieveImage(forKey key: String,
                                inStorageType storageType: StorageType) -> UIImage? {
        switch storageType {
        case .fileSystem:
            if let filePath = self.filePath(forKey: key),
                let fileData = FileManager.default.contents(atPath: filePath.path),
                let image = UIImage(data: fileData) {
                return image
            }
        case .userDefaults:
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                let image = UIImage(data: imageData) {
                return image
            }
        }
        
        return nil
    }
    
    private static func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    static func getBool(_ key: String) -> Bool{
        let dic = [key: false]
        UserDefaults.standard.register(defaults: dic)
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func getInt(_ key: String) -> Int{
        let dic = [key: 0]
        UserDefaults.standard.register(defaults: dic)
        return UserDefaults.standard.integer(forKey: key)
    }
    
    static func getString(_ key: String) -> String{
        let dic = [key: ""]
        UserDefaults.standard.register(defaults: dic)
        return UserDefaults.standard.string(forKey: key)!
    }
    
    static func getString(suiteName: String, _ key: String) -> String{
        let dic = [key: ""]
        UserDefaults(suiteName: suiteName)?.register(defaults: dic)
        return UserDefaults(suiteName: suiteName)!.string(forKey: key)!
    }
    
    static func getDict(_ key: String) -> [String: Any]{
        let dic = [key: ["": ""]]
        UserDefaults.standard.register(defaults: dic)
        return UserDefaults.standard.dictionary(forKey: key)!
    }
    
    static func getArray(_ key: String) -> Array<Any>{
        let dic = [key: [""]]
        UserDefaults.standard.register(defaults: dic)
        return UserDefaults.standard.array(forKey: key)!
    }
    
    static func getObject(_ key: String) -> Data?{
        return UserDefaults.standard.data(forKey: key)
    }
    
    static func getObject(suiteName: String, _ key: String) -> Data?{
        return UserDefaults(suiteName: suiteName)?.data(forKey: key)
    }
    
    static func remove(_ key: String){
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func remove(suiteName: String, _ key: String){
        UserDefaults(suiteName: suiteName)?.removeObject(forKey: key)
    }
    
    static func removeAll(){
        func clearTempFolder() {
            let fileManager = FileManager.default
            let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
            let documentsPath = documentsUrl.path
            
            do {
                if let documentPath = documentsPath
                {
                    let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                    print("all files in cache: \(fileNames)")
                    for fileName in fileNames {
                        print("find \(fileName)")
                        if (fileName.hasSuffix(".png"))
                        {
                            let filePathName = "\(documentPath)/\(fileName)"
                            try fileManager.removeItem(atPath: filePathName)
                        }
                    }
                    
                    let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                    print("all files in cache after deleting images: \(files)")
                }
                
            } catch {
                print("Could not clear temp folder: \(error)")
            }
        }
        
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        
        clearTempFolder()
    }
    
    static func removeAll(_ exception: [String]){
        var exceptionList : [String: Any] = [:]
        for id in exception {
            exceptionList[id] = Storage.getString(id)
        }
        removeAll()
        for id in exception {
            Storage.save(id, exceptionList[id]!)
        }
    }
    
    static func printAll(){
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }
    }
    
}
