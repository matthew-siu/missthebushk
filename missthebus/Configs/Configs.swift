//
//  Configs.swift
//  autotoll-build-release
//
//  Created by Ding Lo on 17/2/2021.
//

import Foundation
import UIKit

@objc
class Configs: NSObject {}

extension Configs {
    
    enum Network {
        
        static let timeout: TimeInterval = 40
        // KMB
        static var kmbURL: String {
            return "https://data.etabus.gov.hk/v1/transport/kmb"
        }
        // CITY BUS
        static var ctbURL: String {
            return "https://rt.data.gov.hk/v1/transport/citybus-nwfb"
        }
    }
    
    // local storage key
    enum Storage {
        static let KEY_LANGUAGE = "KEY_LANGUAGE" // save custom language
        static let KEY_ROUTES = "KEY_ROUTES" // save all routes
        static let KEY_STOPS = "KEY_STOPS" // save all stops
        static let KEY_ROUTESTOPS = "KEY_ROUTESTOPS"
        static let KEY_LAST_UPDATE = "KEY_LAST_UPDATE" // save last update of bus info
    }
    
    enum App {
        static var releaseVersionNumber: String? {
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        }

        static var buildVersionNumber: String? {
            return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        }
        
        static let version = (Configs.App.releaseVersionNumber ?? "") + "." + (Configs.App.buildVersionNumber ?? "")
    }
}
