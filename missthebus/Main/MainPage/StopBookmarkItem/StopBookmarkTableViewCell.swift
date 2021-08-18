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

class StopBookmarkTableViewCell: UITableViewCell {
    
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
    
    struct ETAView{
        let view: UIStackView
        let label: UILabel
        let unit: UILabel
    }
    var etaViewList: [ETAView]{
        return [
            ETAView(view: self.eta1view, label: self.eta1label, unit: self.eta1unit),
            ETAView(view: self.eta2view, label: self.eta2label, unit: self.eta2unit),
            ETAView(view: self.eta3view, label: self.eta3label, unit: self.eta3unit)
        ]
    }

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
        self.eta1unit.text = "stop_mins".localized()
        self.eta2unit.text = "stop_mins".localized()
        self.eta3unit.text = "stop_mins".localized()
        
        self.routeNumLabel.useTextStyle(.title1)
        self.routeDestLabel.useTextStyle((currentLanguage != .english) ? .label_en : .label)
        
        self.routeView.addTarget(self, action: #selector(onSelected), for: .touchUpInside)
        
        self.eta1view.isHidden = true
        self.eta2view.isHidden = true
        self.eta3view.isHidden = true
    }
    
    func setInfo(stop: MainPage.BookmarkItem, etaItem: MainPage.ETAItem?){
        // General View
        self.index = stop.index
        self.routeNumLabel.text = String(stop.routeNum)
        self.routeDestLabel.text = stop.currentStop
        self.routeOrigLabel.text = "\("route_to".localized()) \(stop.destStop)"
        
        if (stop.company == .KMB){
            if let image = UIImage(named: "KmbLogo") {
                self.busCompanyIcon.image = image.resized(toHeight: self.iconLayout.frame.height)
                self.busCompanyIcon.sizeToFit()
            }
        }
        
        // ETA View
        if let etaItem = etaItem {
            for (index, eta) in etaItem.etaList.enumerated(){
                if let eta = eta{
                    self.etaViewList[index].view.isHidden = false
                    self.etaViewList[index].label.text = eta
                }
            }
        }
    }
    
    @objc func onSelected(){
        print("onSelected")
        self.delegate?.onSelect(self.index)
    }
    
}

extension StopBookmarkTableViewCell{
    
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