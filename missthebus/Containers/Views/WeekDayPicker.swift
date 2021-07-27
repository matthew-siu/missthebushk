//
//  WeekDayPicker.swift
//  Caine18RoadSDK
//
//  Created by Matthew Siu on 10/9/2019.
//  Copyright © 2019 ESD. All rights reserved.
//

import UIKit

class WeekDayPicker: UILabel {
    let radius: CGFloat = 15;
    
    public var isSelected = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    func initialize(){
//        setCornerRadius(radius)
        self.useTextStyle(.label_sub)
        self.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onSelect))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
        setUnselectedView()
    }
    
    @objc private func onSelect(sender: UILabel){
        select()
    }
    
    func select(){
        isSelected = !isSelected
        if (isSelected){
            setSelectedView()
        }else{
            setUnselectedView()
        }
    }
    
    func select(_ onSelected: Bool){
        isSelected = onSelected
        if (isSelected){
            setSelectedView()
        }else{
            setUnselectedView()
        }
    }
    
    private func setSelectedView(){
//        self.layer.borderWidth = 0
//        self.backgroundColor = #colorLiteral(red: 0.6130179167, green: 0.7323217988, blue: 0.008159480989, alpha: 1)
        self.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        self.useTextStyle(.label_sub_bold)
        
    }
    
    private func setUnselectedView(){
//        self.layer.borderWidth = 1
//        self.layer.borderColor = #colorLiteral(red: 0.924646616, green: 0.908230722, blue: 0.8868125081, alpha: 1)
//        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.textColor = .black
        self.useTextStyle(.label_sub)
    }
    
    func setCornerRadius(_ radius: CGFloat){
        self.layer.cornerRadius = radius
    }
    
    
}
