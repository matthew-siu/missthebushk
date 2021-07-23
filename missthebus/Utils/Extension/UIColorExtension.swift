//
//  UIColorExtension.swift
//  autotoll-build-release
//
//  Created by Ding Lo on 17/2/2021.
//

import Foundation
import UIKit

extension UIColor {
    
    // This is the commonly used "#FFFFFF" format
    convenience public init(hexString: String, alpha: CGFloat = 1) {
        var hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString = hexString.replacingOccurrences(of: "#", with: "")
        }
        
        assert(hexString.count == 6, "Invalid color hex code!!!")
        
        let scanner = Scanner(string: hexString)
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    // This is the commonly used "#FFFFFF" format
    convenience public init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red color code!!!")
        assert(green >= 0 && green <= 255, "Invalid green color code!!!")
        assert(blue >= 0 && blue <= 255, "Invalid blue color code!!!")
        
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
}
