//
//  StopReminderTableViewCell.swift
//  missthebus
//
//  Created by Matthew Siu on 30/7/2021.
//

import UIKit

protocol StopReminderCellDelegate: class {
    func onSelect(_ index: Int)
}

class StopReminderTableViewCell: UITableViewCell {
    
    // route view
    @IBOutlet weak var routeView: SoftUIView!
    @IBOutlet weak var routeNumLabel: UILabel!
    @IBOutlet weak var busCompanyIcon: UIImageView!
    @IBOutlet weak var iconLayout: UIView!
    @IBOutlet weak var routeDestLabel: UILabel!
    @IBOutlet weak var routeOrigLabel: UILabel!
    
    
    @IBOutlet weak var eta1view: UIStackView!
    @IBOutlet weak var eta1label: UILabel!
    @IBOutlet weak var eta1unit: UILabel!
    
    @IBOutlet weak var eta2view: UIStackView!
    @IBOutlet weak var eta2label: UILabel!
    @IBOutlet weak var eta2unit: UILabel!
    
    @IBOutlet weak var eta3view: UIStackView!
    @IBOutlet weak var eta3label: UILabel!
    @IBOutlet weak var eta3unit: UILabel!
    

    var index = -1
    var delegate: StopReminderCellDelegate?
    
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
    
    func setInfo(stop: MainPage.BookmarkItem, etaItem: MainPage.ETAItem?){
        self.index = stop.index
        self.routeNumLabel.text = String(stop.routeNum)
        self.routeNumLabel.useTextStyle(.title1)
        self.routeDestLabel.text = stop.destStop
        self.routeDestLabel.useTextStyle((currentLanguage != .english) ? .label_en : .label)
        self.routeOrigLabel.text = stop.currentStop
        
        if (stop.company == .KMB){
            if let image = UIImage(named: "KmbLogo") {
                self.busCompanyIcon.image = image.resized(toHeight: self.iconLayout.frame.height)
                self.busCompanyIcon.sizeToFit()
            }
        }
        
        self.eta1view.isHidden = false
        self.eta2view.isHidden = false
        self.eta3view.isHidden = false
        if let etaItem = etaItem, let eta1 = etaItem.eta1{
            self.eta1label.text = eta1
            if let eta2 = etaItem.eta2{
                self.eta2label.text = eta2
                if let eta3 = etaItem.eta3{
                    self.eta3label.text = eta3
                }else{
                    self.eta3view.isHidden = true
                }
            }else{
                self.eta2view.isHidden = true
                self.eta3view.isHidden = true
            }
        }else{
            print("sth is nil")
            self.eta1view.isHidden = true
            self.eta2view.isHidden = true
            self.eta3view.isHidden = true
        }
        
        self.routeView.addTarget(self, action: #selector(onSelected), for: .touchUpInside)
    }
    
    @objc func onSelected(){
        print("onSelected")
        self.delegate?.onSelect(self.index)
    }
    
}

extension StopReminderTableViewCell{
    
    func initSoftUI(_ obj: SoftUIView, inverted: Bool? = false, type: SoftUIViewType? = .pushButton){
        obj.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        obj.cornerRadius = 10
        obj.shadowOffset = .init(width: 2, height: 2)
        obj.shadowOpacity = 1
        obj.type = .toggleButton
        
        if let inverted = inverted, let type = type {
            obj.isSelected = inverted
            obj.type = type
        }
    }
}
