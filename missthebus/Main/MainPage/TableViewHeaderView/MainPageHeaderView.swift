//
//  MainPageHeaderView.swift
//  missthebus
//
//  Created by Matthew Siu on 17/8/2021.
//

import UIKit

class MainPageHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var headerImgView = UIImageView()
    var headerLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setContent(imgName: String, title: String) {
        self.backgroundColor = UIColor.SoftUI.major
        
        let headerImg = UIImage(named: imgName)
        headerImg?.withTintColor(UIColor.MTB.darkGray, renderingMode: .alwaysTemplate)
        self.headerImgView = UIImageView(frame: .init(x: 20, y: 0, width: 20, height: 20))
        self.headerImgView.image = headerImg
        self.headerImgView.addShadow()
        self.headerImgView.center.y = self.center.y
        
        self.headerLabel = UILabel(frame: .init(x: self.headerImgView.frame.maxX + 10, y: 0, width: self.frame.width, height: 30))
        self.headerLabel.tintColor = UIColor.MTB.darkGray
        self.headerLabel.useTextStyle(.label)
        self.headerLabel.text = title
        self.headerLabel.sizeToFit()
        self.headerLabel.center.y = self.center.y
        
        self.addSubview(self.headerImgView)
        self.addSubview(self.headerLabel)
    }

}
