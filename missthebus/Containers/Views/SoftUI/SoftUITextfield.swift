//
//  SoftUITextfield.swift
//  missthebus
//
//  Created by Matthew Siu on 8/7/2021.
//

import UIKit

@objcMembers
open class SoftUITextfield: UITextField {

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open var softUIBackgroundLayer: SoftUIView!
    
    open func setThemeColor(majorColor: UIColor, darkColor: UIColor, lightColor: UIColor){
        initUI()
        setThemeColor(majorColor, darkColor, lightColor)
    }
    
}

private extension SoftUITextfield {
    
    func initUI(){
        createSubLayers()
    }

    func createSubLayers() {
        softUIBackgroundLayer = {
            let softUIView = createSoftUIView()
            softUIView.isSelected = true
            softUIView.type = .staticView
            softUIView.isUserInteractionEnabled = false
            self.addSubview(softUIView)
            self.sendSubviewToBack(softUIView)
            return softUIView
        }()
    }
    
    func createSoftUIView() -> SoftUIView{
        return SoftUIView(frame: .init(origin: CGPoint(x: 0, y: 0), size: self.frame.size))
    }
    
    func setThemeColor(_ majorColor: UIColor, _ darkColor: UIColor, _ lightColor: UIColor){
        
        self.softUIBackgroundLayer.setThemeColor(majorColor, darkColor, lightColor)
    }


}


