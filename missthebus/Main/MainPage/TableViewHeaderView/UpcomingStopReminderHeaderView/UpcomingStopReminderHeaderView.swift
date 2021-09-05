//
//  UpcomingStopReminderHeaderView.swift
//  missthebus
//
//  Created by Matthew Siu on 2/9/2021.
//

import UIKit

protocol ShowUpcomingNotiDelegate {
    func onClickShowUpcomingNoti()
}

class UpcomingStopReminderHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var reminderIcon: UIImageView!
    @IBOutlet weak var reminderNameLabel: UILabel!
    @IBOutlet weak var countDownSoftUIView: SoftUIView!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet weak var countDownTimer: UILabel!
    @IBOutlet weak var landSoftUIView: SoftUIView!
    @IBOutlet weak var landLabel: UILabel!
    
    var timer: Timer?
    var viewModel: MainPage.UpcomingReminderItem.UpcomingHeader?
    var delegate: ShowUpcomingNotiDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.backgroundColor = UIColor.SoftUI.major
        
        self.reminderNameLabel.text = ""
        self.reminderNameLabel.useTextStyle(.title2)
        self.startTimeLabel.useTextStyle(.label_sub)
        self.startTimeLabel.textColor = UIColor.MTB.darkGray
        
        self.countDownSoftUIView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.countDownSoftUIView.cornerRadius = 10
        self.countDownSoftUIView.shadowOffset = .init(width: 2, height: 2)
        self.countDownSoftUIView.shadowOpacity = 1
        self.countDownSoftUIView.type = .staticView
        self.countDownSoftUIView.isSelected = true
        
        self.countDownTimer.useTextStyle(.title1)
        self.updateTime()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        
        self.landSoftUIView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.landSoftUIView.cornerRadius = 10
        self.landSoftUIView.shadowOffset = .init(width: 2, height: 2)
        self.landSoftUIView.shadowOpacity = 1
        self.landSoftUIView.addTarget(self, action: #selector(self.onClickShowNoti), for: .touchUpInside)
        
        self.landLabel.text = "main_upcoming_pin_noti".localized()
        self.landLabel.useTextStyle(.label)
    }
    
    func setContent(reminder: MainPage.UpcomingReminderItem.UpcomingHeader?) {
        if let reminder = reminder{
            
            if let tagViewModel = StopReminder.getTagViewModel(reminder.type){
                self.reminderIcon.image = UIImage(named: tagViewModel.img)
                self.reminderIcon.addShadow()
            }
            self.startTimeLabel.text = Utils.convertTime(time: reminder.startTime, toPattern: "HH:mm")
            self.reminderNameLabel.text = reminder.name
        }
    }
    
    @objc func onClickShowNoti(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge, .carPlay], completionHandler: { (granted, error) in
            if granted {
                self.delegate?.onClickShowUpcomingNoti()
            } else {
                print("不允許")
            }
        })
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
