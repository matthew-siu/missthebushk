//
//  ReminderNameCollectionViewCell.swift
//  missthebus
//
//  Created by Matthew Siu on 28/7/2021.
//

import UIKit

protocol ReminderTagDelegate {
    func onClickTag(type: SetReminderPage.NameSample?)
}

class ReminderNameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var softBgView: SoftUIView!
    @IBOutlet weak var tagImage: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    
    var delegate: ReminderTagDelegate?
    var type: SetReminderPage.NameSample?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setInfo(type: SetReminderPage.NameSample, selected: Bool){
        self.type = type
        self.softBgView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.softBgView.cornerRadius = 10
        self.softBgView.shadowOffset = .init(width: 3, height: 3)
        self.softBgView.shadowOpacity = 1
        
        self.softBgView.type = .toggleButton
        self.tagImage.image = UIImage(named: type.img)
        self.tagImage.addShadow()
        self.tagLabel.text = type.name
        self.tagLabel.useTextStyle(.label_sub)
        
        self.toggleView(selected)
        self.softBgView.addTarget(self, action: #selector(onClick), for: .touchDown)
    }
    
    @objc func onClick(){
        self.delegate?.onClickTag(type: self.type)
    }
    
    private func toggleView(_ selected: Bool){
        self.softBgView.isSelected = selected
    }
    
    
}
