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
            case regular = "Regular"
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
    case title2
    case title2_bold
    case label
    case label_en
    case label_sub
    case label_sub_bold
    case label_sub_mini
    
    fileprivate var style: Style {
        switch self {
        case .header1:      return (35, .avenirNext(.regular))
        case .header2:      return (30, .avenirNext(.regular))
        case .title1:       return (24, .avenirNext(.regular))
        case .title2:       return (20, .avenirNext(.regular))
        case .title2_bold:  return (20, .avenirNext(.medium))
        case .subhead1:     return (17, .avenirNext(.bold))
        case .label:        return (16, .avenirNext(.regular))
        case .label_en:     return (20, .avenirNext(.regular))
        case .label_sub:    return (14, .avenirNext(.regular))
        case .label_sub_bold:   return (14, .avenirNext(.bold))
        case .label_sub_mini:   return (12, .avenirNext(.regular))
        }
    }
    
    var font: UIFont {
        let font = UIFont.init(name: self.style.font.fontIdentifier, size: self.style.size)

        
        assert(font != nil, "Font config fail! Check FontConfig.swift!")
        
        return font!
    }
}
