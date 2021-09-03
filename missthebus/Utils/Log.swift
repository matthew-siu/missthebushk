//
//  Log.swift
//  Caine18RoadSDK
//
//  Created by Matthew Siu on 7/2/2020.
//  Copyright © 2020 ESD. All rights reserved.
//

import Foundation

class Log{
    enum TAG: String {
        case GENERAL = "General"
        case RUNTIME = "RUNTIME"
    }
//    public static func nslog(_ log: String){
//        if (permitted) {
//            NSLog(log)
//            printLog(log)
//        }
//    }
//    
//    public static func log(_ log: String){
//        if (permitted) {
//            print(log)
//            printLog(log)
//        }
//    }
    
    public static func d(_ TAG: TAG = .GENERAL, _ log: String){
//        print("\(TAG.rawValue): \(log)")
        NSLog("\(TAG.rawValue): \(log)")
    }
    
    public static func o(_ TAG: TAG = .GENERAL, _ log: String){
        NSLog("\(TAG.rawValue): \(log)")
    }
    
//    private static var permitted: Bool {
//        return (Config.env.PERMISSION > Config.LEVEL.STAGE.rawValue)
//    }
}
