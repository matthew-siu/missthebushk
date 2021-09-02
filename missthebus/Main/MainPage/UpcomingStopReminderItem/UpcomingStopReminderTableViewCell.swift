//
//  UpcomingStopReminderTableViewCell.swift
//  missthebus
//
//  Created by Matthew Siu on 20/8/2021.
//

import UIKit

class UpcomingStopReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var bgSoftUIView: SoftUIView!
    @IBOutlet weak var routeNum: UILabel!
    @IBOutlet weak var routeCompanyIcon: UIImageView!
    
    @IBOutlet weak var routeStop1Label: UILabel!
    @IBOutlet weak var routeStop1Eta1Label: UILabel!
    @IBOutlet weak var routeStop1Eta2Label: UILabel!
    @IBOutlet weak var routeStop1Eta3Label: UILabel!
    
    @IBOutlet weak var routeStop2Label: UILabel!
    @IBOutlet weak var routeStop2Eta1Label: UILabel!
    @IBOutlet weak var routeStop2Eta2Label: UILabel!
    @IBOutlet weak var routeStop2Eta3Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.bgSoftUIView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.bgSoftUIView.cornerRadius = 10
        self.bgSoftUIView.shadowOffset = .init(width: 2, height: 2)
        self.bgSoftUIView.shadowOpacity = 1
        self.bgSoftUIView.type = .staticView
    }
    
    func setInfo(routes: [MainPage.UpcomingReminderItem.ReminderRouteItem]){
        
        self.routeNum.text = route.routeNum
        if (routes.count > 0){
            
        }
        if (routes.count > 1){
            
        }
        self.stop1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
