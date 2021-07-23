//
//  SoftUIButton.swift
//  missthebus
//
//  Created by Matthew Siu on 8/7/2021.
//

import UIKit

class SoftUIButton: SoftUIView {

    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    open var label = UILabel()
    

}


private extension SoftUIButton {
    
    func initUI(){
        
        // label default style
        self.label.translatesAutoresizingMaskIntoConstraints = false
        if let font = UIFont.init(name: "AvenirNext-Regular", size: 24){
            self.label.useFont(font: font)
        }
        self.label.textColor = .darkText
        // center label
        self.setContentView(self.label, ableTouch: true)
        self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

}
