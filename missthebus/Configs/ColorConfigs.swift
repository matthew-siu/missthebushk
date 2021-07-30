//
//  ColorConfigs.swift
//  autotoll-build-release
//
//  Created by Ding Lo on 17/2/2021.
//

import Foundation
import UIKit

enum Color {
    case white
    case black
    case lightGrey
    case darkGrey
    case darkBlue
    case orange
    case darkGreen
}


// for more about Neumorphism
// check out https://neumorphism.io/#ad0101

extension UIColor {
    struct SoftUI {
        static var major: UIColor  { return UIColor(hexString: "DCE4F2") }
        static var dark: UIColor { return UIColor(hexString: "bbc2ce") }
        static var light: UIColor { return UIColor(hexString: "fdffff") }
    }

    struct SoftLaunch{
        
        static var major: UIColor  { return UIColor(hexString: "555555") }
        static var dark: UIColor { return UIColor(hexString: "282828") }
        static var light: UIColor { return UIColor(hexString: "828282") }
    }
}

extension Color {
    var uiColor: UIColor {
        switch self {
        case .white:            return UIColor(hexString: "#FFFFFF")
        case .black:            return UIColor(hexString: "#000000")
        case .lightGrey:        return UIColor(hexString: "#D2D2D2")
        case .darkGrey:         return UIColor(hexString: "#343434")
        case .darkBlue:         return UIColor(hexString: "#075CA9")
        case .orange:           return UIColor(hexString: "#F18F34")
        case .darkGreen:        return UIColor(hexString: "#53AF21")
        }
    }
}
