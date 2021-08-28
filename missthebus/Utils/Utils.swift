//
//  Utils.swift
//  Caine18RoadSDK
//
//  Created by Matthew Siu on 16/7/2019.
//  Copyright © 2019 DerekIp. All rights reserved.
//

import Foundation
import UIKit

class Utils{
    
    //FIXME: getString by preferred language
    static func getString(_ id: String) -> String{
//        let path = Bundle.main.path(forResource: (Storage.getString("preferred_language") == "zh") ? "zh-Hant" : "en", ofType: "lproj")
//        let bundle = Bundle(path: path!)
//        return NSLocalizedString(id, tableName: nil, bundle: bundle!, value: "", comment: "")
        return NSLocalizedString(id, comment: "")
    }
    
    static func isEmpty(_ msg: Any) -> Bool{
        guard let str : String = msg as? String else{
            return false
        }
        let trim = str.trimmingCharacters(in: .whitespacesAndNewlines)
        return (trim == "" || trim.isEmpty)
    }
    
    static func error(_ msg: String) -> Error{
        let error = NSError(domain:"", code: 0, userInfo: [
            NSLocalizedDescriptionKey: Utils.getString(msg)
        ])
        return error
    }
    
    // custom error
    static func error(msg: String, code: Int) -> Error{
        let error = NSError(domain:"", code: code, userInfo: [
            NSLocalizedDescriptionKey: Utils.getString(msg)
        ])
        return error
    }
    
    // custom error
    static func error(msg: String, code: String, result: String, type: String, stackTrace: String) -> Error{
        let error = NSError(domain:"", code: 200, userInfo: [
            NSLocalizedDescriptionKey: Utils.getString(msg),
            "level": "ERROR",
            "code": code,
            "result": result,
            "type": type,
            "stackTrace": stackTrace
        ])
        return error
    }
    
    // custom error
    static func error(msg: String, code: Int, result: String, type: String, stackTrace: String) -> Error{
        let error = NSError(domain:"", code: 403, userInfo: [
            NSLocalizedDescriptionKey: Utils.getString(msg),
            "level": "ERROR",
            "code": code,
            "result": result,
            "type": type,
            "stackTrace": stackTrace
        ])
        return error
    }
    
    static func handleError(_ response: Dictionary<String, Any>) -> Error{
        print("handleError: \(response)")
        let codeStr = response["code"] as! String
        let code:Int? = Int(codeStr)
        guard let msg = response["msg"] as? String else{
            return error(msg: "smc_msg_err_404".localized(), code: code ?? 404)
        }
        switch code {
        case 401:
            return error(msg: "smc_msg_err_unauthorized".localized(), code: 401)
        case 404:
            return error(msg: "smc_msg_err_404".localized(), code: 401)
        case 504:
            return error(msg: "msg_err_timeout".localized(), code: 504)
        case -1004:
            return error(msg: "msg_err_no_connection".localized(), code: -1004)
        default:
            return error(msg: msg, code: code ?? 404)
        }
    }
    
    // for swift 4
    static func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func getScreenWidth() -> CGFloat{
        return UIScreen.main.bounds.width
    }
    
    static func getScreenHeight() -> CGFloat{
        return UIScreen.main.bounds.height
    }
    
    static func simplifyTime(_ time: String) -> String{
        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        inFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let outFormatter = DateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        outFormatter.dateFormat = "d/M"
        
        let inStr = time
        let date = inFormatter.date(from: inStr)!
        let outStr = outFormatter.string(from: date)
        return outStr.description
    }
    
    static func convertTime(time: String, fromPattern: String, toPattern: String) -> String{
        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        inFormatter.dateFormat = fromPattern
        
        let outFormatter = DateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        outFormatter.dateFormat = toPattern
        
        let inStr = time
        let date = inFormatter.date(from: inStr)!
        let outStr = outFormatter.string(from: date)
        return outStr.description
    }
    
    static func convertTime(time: Date, toPattern: String) -> String{
        let outFormatter = DateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        outFormatter.dateFormat = toPattern
        
        let outStr = outFormatter.string(from: time)
        return outStr.description
    }
    
    static func getCurrentTime(pattern: String) -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter.string(from: date)
    }
    
    static func convert2Date(time: String, pattern: String) -> Date? {
        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        inFormatter.dateFormat = pattern
        return inFormatter.date(from: time)
    }
    
    static func compareTime(_ first: String, _ second: String) -> Bool{
        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        inFormatter.dateFormat = "d/M"
        
        let date1 = inFormatter.date(from: first)!
        let date2 = inFormatter.date(from: second)!
        
        return (date1 >= date2)
        
    }
    
    static func convertUIImageToData(_ img: UIImage) -> Data{
//        let imageData: Data = img.pngData()!
        let imageData: Data = img.pngData()!
        return imageData
        
    }
    
    static func cleanSubviews(_ view: UIView){
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
    }
    
    static func changeFont(font: UIFont?) -> UIFont?{
        // You may test another font like Courier
        let newFont = "AvenirNext-Regular"
        if (UIFont.fontNames(forFamilyName: newFont).count > 0){
            if let uifont = font {
                //Courier
                return UIFont(name: newFont, size: uifont.pointSize) ?? font
            }else{
                return font
            }
        }else{
            return font
        }
        
    }
    
    static func forceFont(font: UIFont?) -> UIFont?{
        // You may test another font like Courier
        let newFont = "Arial"
        if (UIFont.fontNames(forFamilyName: newFont).count > 0){
            if let uifont = font {
                //Courier
                return UIFont(name: newFont, size: uifont.pointSize) ?? font
            }else{
                return font
            }
        }else{
            return font
        }
        
    }
}

