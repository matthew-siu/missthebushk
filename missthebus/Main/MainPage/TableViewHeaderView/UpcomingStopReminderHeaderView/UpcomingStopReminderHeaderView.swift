//
//  UpcomingStopReminderHeaderView.swift
//  missthebus
//
//  Created by Matthew Siu on 2/9/2021.
//

import UIKit

class UpcomingStopReminderHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var reminderIcon: UIImageView!
    @IBOutlet weak var reminderNameLabel: UILabel!
    @IBOutlet weak var countDownSoftUIView: SoftUIView!
    @IBOutlet weak var countDownTimer: UILabel!
    @IBOutlet weak var landSoftUIView: SoftUIView!
    @IBOutlet weak var landLabel: UILabel!
    
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.reminderNameLabel.text = ""
        self.reminderNameLabel.useTextStyle(.title2)
        
        self.countDownSoftUIView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.countDownSoftUIView.cornerRadius = 10
        self.countDownSoftUIView.shadowOffset = .init(width: 2, height: 2)
        self.countDownSoftUIView.shadowOpacity = 1
        self.countDownSoftUIView.type = .staticView
        self.countDownSoftUIView.isSelected = true
        
        self.countDownTimer.useTextStyle(.title1)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        
        self.landSoftUIView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.landSoftUIView.cornerRadius = 10
        self.landSoftUIView.shadowOffset = .init(width: 2, height: 2)
        self.landSoftUIView.shadowOpacity = 1
        self.landSoftUIView.addTarget(self, action: #selector(self.onClickLanded), for: .touchUpInside)
        
        self.landLabel.text = "已經上車".localized() + "🤤"
        self.landLabel.useTextStyle(.label)
    }
    
    func setContent(reminder: MainPage.UpcomingReminderItem.UpcomingHeader?) {
        if let reminder = reminder{
            self.backgroundColor = UIColor.SoftUI.major
            
            if let tagViewModel = StopReminder.getTagViewModel(reminder.type){
                self.reminderIcon.image = UIImage(named: tagViewModel.img)
                self.reminderIcon.addShadow()
            }
            self.reminderNameLabel.text = reminder.name
        }
    }
    
    @objc func onClickLanded(){
        
    }
    
    @objc func updateTime() {
        self.countDownTimer.text = Utils.getCurrentTime(pattern: "HH:mm")
    }
    
    func stopCountTime(){
        print("stopCountTime")
        self.timer?.invalidate()
        self.timer = nil
    }

}
