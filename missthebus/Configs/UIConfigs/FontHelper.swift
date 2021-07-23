//
//  FontHelper.swift
//  autotoll-build-release
//
//  Created by Ding Lo on 17/2/2021.
//

import Foundation
import UIKit

// MARK - General method of text configuration
protocol TextStyleConfigurable {
    func useFont(font: UIFont)
}

extension TextStyleConfigurable {
    @discardableResult
    func useTextStyle(_ textStyle: TextStyle) -> Self {
        self.useFont(font: textStyle.font)
        return self
    }
}
//

extension UILabel: TextStyleConfigurable {
    func useFont(font: UIFont) {
        self.font = font
    }
}

extension UITextView: TextStyleConfigurable {
    func useFont(font: UIFont) {
        self.font = font
    }
}

extension UITextField: TextStyleConfigurable {
    func useFont(font: UIFont) {
        self.font = font
    }
}

extension UIButton: TextStyleConfigurable {
    func useFont(font: UIFont) {
        self.titleLabel?.font = font
    }
}


