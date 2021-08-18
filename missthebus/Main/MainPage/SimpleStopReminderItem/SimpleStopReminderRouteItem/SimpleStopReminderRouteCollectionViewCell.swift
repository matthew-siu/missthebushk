//
//  SimpleStopReminderRouteCollectionViewCell.swift
//  missthebus
//
//  Created by Matthew Siu on 18/8/2021.
//

import UIKit

class SimpleStopReminderRouteCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var softUIView: SoftUIView!
    @IBOutlet weak var routeImg: UIImageView!
    @IBOutlet weak var routeNumLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.initUI()
    }

    func initUI(){
        self.softUIView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.softUIView.cornerRadius = 10
        self.softUIView.shadowOffset = .init(width: 2, height: 2)
        self.softUIView.shadowOpacity = 1
        self.softUIView.type = .staticView
        self.softUIView.isSelected = true
    }
    
    func setInfo(viewModel: MainPage.ReminderItem.ReminderRouteItem){
        if (viewModel.company == .KMB){
            self.routeImg.image = UIImage(named: "kmbBus")
        }
        self.routeNumLabel.text = viewModel.routeNum
        
    }
    
}
