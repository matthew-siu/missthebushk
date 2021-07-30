//
//  StopReminderTableViewCell.swift
//  missthebus
//
//  Created by Matthew Siu on 30/7/2021.
//

import UIKit

protocol StopReminderCellDelegate: class {
//    func onSelect(stop: KmbStop)
}

class StopReminderTableViewCell: UITableViewCell {
    
    // route view
    @IBOutlet weak var routeView: SoftUIView!
    @IBOutlet weak var routeNumLabel: UILabel!
    @IBOutlet weak var busCompanyIcon: UIImageView!
    @IBOutlet weak var iconLayout: UIView!
    @IBOutlet weak var routeDestLabel: UILabel!
    @IBOutlet weak var routeOrigLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initUI(){
        self.initSoftUI(self.routeView)
    }
    
    func setInfo(routeNum: String, destStopName: String, currentStopName: String, busCompany: BusCompany){
        
        self.routeNumLabel.text = String(routeNum)
        self.routeNumLabel.useTextStyle(.header2)
        self.routeDestLabel.text = destStopName
        self.routeDestLabel.useTextStyle((currentLanguage != .english) ? .label_en : .label)
        self.routeOrigLabel.text = currentStopName
        
        if (busCompany == .KMB){
            if let image = UIImage(named: "KmbLogo") {
                self.busCompanyIcon.image = image.resized(toHeight: self.iconLayout.frame.height)
                self.busCompanyIcon.sizeToFit()
            }
        }
        
        self.routeView.addTarget(self, action: #selector(onSelected), for: .touchUpInside)
    }
    
    @objc func onSelected(){
        
    }
    
}

extension StopReminderTableViewCell{
    
    func initSoftUI(_ obj: SoftUIView, inverted: Bool? = false, type: SoftUIViewType? = .pushButton){
        obj.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        obj.cornerRadius = 10
        obj.shadowOffset = .init(width: 2, height: 2)
        obj.shadowOpacity = 1
        
        if let inverted = inverted, let type = type {
            obj.isSelected = inverted
            obj.type = type
        }
    }
}
