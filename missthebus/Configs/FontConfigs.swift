//
//  FontConfigs.swift
//  autotoll-build-release
//
//  Created by Ding Lo on 17/2/2021.
//

import Foundation
import UIKit

// Font related
fileprivate extension Configs {
    enum Font {
        case avenirNext(Weight)
        
        // Font Weight Configurations
        enum Weight: String {
            case medium = "Medium"
            case heavy  = "Heavy"
            case bold   = "Bold"
            case italic = "Italic"
        }
        
        // Helper, defines the name of font
        var fontName: String {
            switch self {
            case .avenirNext: return "AvenirNext"
            }
        }
        
        // Helper, defines the id of font, use in creating ui font
        var fontIdentifier: String {
            switch self {
            case let .avenirNext(weight): return "\(self.fontName)-\(weight)"
            }
        }
    }
}

// Display related
enum TextStyle {
    fileprivate typealias Style = (size: CGFloat, font: Configs.Font)
    
    case header1
    case header2
    case subhead1
    case title1
    case button
    case body2
    case body1
    case caption1
    case remarks1
    
    fileprivate var style: Style {
        switch self {
        case .header1:      return (35, .avenirNext(.medium))
        case .header2:      return (30, .avenirNext(.medium))
        case .title1:       return (19, .avenirNext(.medium))
        case .subhead1:     return (17, .avenirNext(.medium))
        case .button:       return (16, .avenirNext(.medium))
        case .body2:        return (14, .avenirNext(.heavy))
        case .body1:        return (14, .avenirNext(.medium))
        case .caption1:     return (12, .avenirNext(.medium))
        case .remarks1:     return (9, .avenirNext(.medium))
        }
    }
    
    var font: UIFont {
        let font = UIFont.init(name: self.style.font.fontIdentifier, size: self.style.size)

//        for family: String in UIFont.familyNames {
//            print("%@", family)
//            for name: String in UIFont.fontNames(forFamilyName: family) {
//                print("  %@", name)
//            }
//        }
        
        assert(font != nil, "Font config fail! Check FontConfig.swift!")
        
        return font!
    }
}
