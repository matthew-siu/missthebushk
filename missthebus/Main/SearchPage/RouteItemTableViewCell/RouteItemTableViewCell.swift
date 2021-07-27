//
//  RouteItemTableViewCell.swift
//  missthebus
//
//  Created by Matthew Siu on 13/7/2021.
//

import UIKit
import MarqueeLabel

class RouteItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var softBgView: SoftUIView!
    @IBOutlet weak var routeNumLabel: UILabel!
    @IBOutlet weak var iconLayout: UIView!
    @IBOutlet weak var busCompanyIcon: UIImageView!
    @IBOutlet weak var routeDestLabel: UILabel!
    @IBOutlet weak var routeOrigLabel: UILabel!
    
    var route: KmbRoute?
    
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
    }
    
    func setInfo(vc: UIViewController, route: KmbRoute){
        self.route = route
        self.routeNumLabel.text = route.route
        self.routeNumLabel.useTextStyle(.title1)
        self.routeDestLabel.text = "\(route.destStop)"
        self.routeDestLabel.useTextStyle((currentLanguage != .english) ? .label_en : .label)
        self.routeOrigLabel.text = "route_from".localized() + " \(route.originStop)"
        
        if (route.company == .KMB){
            if let image = UIImage(named: "KmbLogo") {
                self.busCompanyIcon.image = image.resized(toHeight: self.iconLayout.frame.height)
                self.busCompanyIcon.sizeToFit()
            }
        }
        
        self.softBgView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.softBgView.cornerRadius = 10
        self.softBgView.shadowOffset = .init(width: 2, height: 2)
        self.softBgView.shadowOpacity = 1
    }
}




