//
//  UIViewExtension.swift
//  autotoll-build-release
//
//  Created by Ding Lo on 17/2/2021.
//

import Foundation
import UIKit

// MARK: - Nib helper
extension UIView {
    static func instanceFromNib() -> UIView? {
        let name = String.init(describing: self)
        return UINib(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
    }
    
    func addDashedBorder(color: Color) {
        let color = color.uiColor.cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()

        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5).cgPath

        self.layer.addSublayer(shapeLayer)
    }
}
