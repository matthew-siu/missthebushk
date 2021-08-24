//
//  RouteItemTableViewCell.swift
//  missthebus
//
//  Created by Matthew Siu on 13/7/2021.
//

import UIKit

class RouteItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var softBgView: SoftUIView!
    @IBOutlet weak var routeNumLabel: UILabel!
    @IBOutlet weak var iconLayout: UIView!
    @IBOutlet weak var busCompanyIcon: UIImageView!
    @IBOutlet weak var routeDestLabel: UILabel!
    @IBOutlet weak var routeOrigLabel: UILabel!
    
    var route: SearchPage.RouteItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RouteItemTableViewCell{
    
    func initUI(){
        self.softBgView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.softBgView.cornerRadius = 10
        self.softBgView.shadowOffset = .init(width: 2, height: 2)
        self.softBgView.shadowOpacity = 1
        
        self.routeNumLabel.useTextStyle(.title1)
        self.routeDestLabel.useTextStyle((currentLanguage != .english) ? .label_en : .label)
    }
    
    func setInfo(route: SearchPage.RouteItem){
        self.route = route
        self.routeNumLabel.text = route.routeNum
        
        let attribute1 = [ NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 12)! ]
        let attribute2 = [ NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: (currentLanguage != .english) ? 20 : 16)! ]
        let str1 = NSMutableAttributedString(string: "route_to".localized(), attributes: attribute1)
        let str2 = NSMutableAttributedString(string: " \(route.destStop)", attributes: attribute2)
        str1.append(str2)
        self.routeDestLabel.attributedText = str1
        self.routeOrigLabel.text = "route_from".localized() + " \(route.origStop)"
        
        if (route.company == .KMB){
            if let image = UIImage(named: "KmbLogo") {
                self.busCompanyIcon.image = image.resized(toHeight: self.iconLayout.frame.height)
                self.busCompanyIcon.sizeToFit()
            }
        }else if (route.company == .CTB){
            if let image = UIImage(named: "CityBus") {
                self.busCompanyIcon.image = image.resized(toHeight: self.iconLayout.frame.height)
                self.busCompanyIcon.sizeToFit()
            }
        }else if (route.company == .NWFB){
            if let image = UIImage(named: "NewWorldFirstBus") {
                self.busCompanyIcon.image = image.resized(toHeight: self.iconLayout.frame.height)
                self.busCompanyIcon.sizeToFit()
            }
        }else if (route.company == .NLB){
            if let image = UIImage(named: "NewLantaoBus") {
                self.busCompanyIcon.image = image.resized(toHeight: self.iconLayout.frame.height)
                self.busCompanyIcon.sizeToFit()
            }
        }
    }
}
