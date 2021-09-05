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
    
    @IBOutlet weak var routeStop1View: UIView!
    @IBOutlet weak var routeStop1Icon: UIImageView!
    @IBOutlet weak var routeStop1Label: UILabel!
    @IBOutlet weak var routeStop1Eta1Label: UILabel!
    @IBOutlet weak var routeStop1Eta2Label: UILabel!
    @IBOutlet weak var routeStop1Eta3Label: UILabel!
    
    @IBOutlet weak var routeStop2View: UIView!
    @IBOutlet weak var routeStop2Icon: UIImageView!
    @IBOutlet weak var routeStop2Label: UILabel!
    @IBOutlet weak var routeStop2Eta1Label: UILabel!
    @IBOutlet weak var routeStop2Eta2Label: UILabel!
    @IBOutlet weak var routeStop2Eta3Label: UILabel!
    
    @IBOutlet weak var destStopLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.bgSoftUIView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.bgSoftUIView.cornerRadius = 10
        self.bgSoftUIView.shadowOffset = .init(width: 2, height: 2)
        self.bgSoftUIView.shadowOpacity = 1
        self.bgSoftUIView.type = .staticView
        
        self.routeNum.useTextStyle(.title1)
        self.routeStop1Label.useTextStyle(.label)
        self.routeStop2Label.useTextStyle(.label)
        self.destStopLabel.textColor = UIColor.MTB.darkGray
        
        self.routeStop1Eta1Label.text = "-"
        self.routeStop1Eta2Label.text = "-"
        self.routeStop1Eta3Label.text = "-"
        self.routeStop2Eta1Label.text = "-"
        self.routeStop2Eta2Label.text = "-"
        self.routeStop2Eta3Label.text = "-"
    }
    
    func setInfo(viewModel: MainPage.UpcomingReminderItem.ReminderRouteItem?, etaList: [MainPage.ETAItem]){
        if let viewModel = viewModel{
            self.routeNum.text = viewModel.route.routeNum
            if (viewModel.stops.count > 0){
                let stop = viewModel.stops[0]
                self.routeStop1Label.text = stop.stop
                if let etas = etaList.first(where: {$0.stopId == stop.stopId}){
//                    print("\(stop.stop) \(etas.eta1) \(etas.eta2) \(etas.eta3)")
                    self.routeStop1Eta1Label.text = (self.isValidETA(etas.eta1)) ? etas.eta1 : "-"
                    self.routeStop1Eta2Label.text = (self.isValidETA(etas.eta2)) ? etas.eta2 : "-"
                    self.routeStop1Eta3Label.text = (self.isValidETA(etas.eta3)) ? etas.eta3 : "-"
                }
            }
            if (viewModel.stops.count > 1){
                let stop = viewModel.stops[1]
                self.routeStop2Label.text = stop.stop
                if let etas = etaList.first(where: {$0.stopId == stop.stopId}){
//                    print("\(stop.stop) \(etas.eta1) \(etas.eta2) \(etas.eta3)")
                    self.routeStop2Eta1Label.text = ((self.isValidETA(etas.eta1))) ? etas.eta1 : "-"
                    self.routeStop2Eta2Label.text = ((self.isValidETA(etas.eta2))) ? etas.eta2 : "-"
                    self.routeStop2Eta3Label.text = ((self.isValidETA(etas.eta3))) ? etas.eta3 : "-"
                }
            }
            self.routeStop2View.isHidden = (viewModel.stops.count <= 1)
            
            
            let attribute1 = [ NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 12)! ]
            let attribute2 = [ NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: (currentLanguage != .english) ? 16 : 14)! ]
            let str1 = NSMutableAttributedString(string: "route_to".localized(), attributes: attribute1)
            let str2 = NSMutableAttributedString(string: " \(viewModel.destStop)", attributes: attribute2)
            str1.append(str2)
            self.destStopLabel.attributedText = str1
        }
        
    }
    
    private func isValidETA(_ eta: String?) -> Bool{
        return !(eta == nil || eta == "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
