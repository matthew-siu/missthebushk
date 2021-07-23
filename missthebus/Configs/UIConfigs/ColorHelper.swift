//
//  ColorHelper.swift
//  autotoll-build-release
//
//  Created by Ding Lo on 17/2/2021.
//

import Foundation
import UIKit

// MARK - General method of color configuration

protocol TextColorConfigurable {
    func renderTextColor(color: UIColor)
}

extension TextColorConfigurable {
    @discardableResult
    func useTextColor(_ color: Color, alpha: CGFloat = 1) -> Self {
        self.renderTextColor(color: color.uiColor.withAlphaComponent(alpha))
        return self
    }
}

extension UILabel: TextColorConfigurable {
    func renderTextColor(color: UIColor) {
        self.textColor = color
    }
}

extension UITextView: TextColorConfigurable {
    func renderTextColor(color: UIColor) {
        self.textColor = color
    }
}

extension UITextField: TextColorConfigurable {
    func renderTextColor(color: UIColor) {
        self.textColor = color
    }
}

extension UIButton: TextColorConfigurable {
    func renderTextColor(color: UIColor) {
        self.setTitleColor(color, for: .normal)
    }
    
    @discardableResult
    func useTintColor(color: Color) -> Self {
        self.tintColor = color.uiColor
        return self
    }
    
    @discardableResult
    func useTextColor(color: Color, for state: UIControl.State = .normal) -> Self {
        self.setTitleColor(color.uiColor, for: state)
        return self
    }
}

// MARK: - UIImage
extension UIImage {
    func useTintColor(_ color: Color) -> UIImage {
        return self.tinted(color: color.uiColor)
    }
}

// MARK: - CALayer
extension CALayer {
    func setBorderColor(color: UIColor) {
        self.borderColor = color.cgColor
    }
}


// MARK: - Dedicated for UIView
extension UIView {
    @discardableResult
    func useBackgroundColor(_ color: Color, alpha: CGFloat = 1) -> Self {
        self.setBackgroundColor(color: color.uiColor.withAlphaComponent(alpha))
        return self
    }
    
    func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
}

