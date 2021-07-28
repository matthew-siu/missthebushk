//
//  SetReminderPageViewController.swift
//  missthebus
//
//  Created by Matthew Siu on 26/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Display logic, receive view model from presenter and present
protocol SetReminderPageDisplayLogic: class
{
    func displayCreateState(route: KmbRoute, stop: KmbStop)
}

// MARK: - View Controller body
class SetReminderPageViewController: BaseViewController, SetReminderPageDisplayLogic
{
    // VIP
    var interactor: SetReminderPageBusinessLogic?
    var router: (NSObjectProtocol & SetReminderPageRoutingLogic & SetReminderPageDataPassing)?
    
    // route view
    @IBOutlet weak var routeView: SoftUIView!
    @IBOutlet weak var routeNumLabel: UILabel!
    @IBOutlet weak var busCompanyIcon: UIImageView!
    @IBOutlet weak var iconLayout: UIView!
    @IBOutlet weak var routeDestLabel: UILabel!
    @IBOutlet weak var routeOrigLabel: UILabel!
    
    // name view
    @IBOutlet weak var nameView: SoftUIView!
    @IBOutlet weak var nameTextfield: SoftUITextfield!
    @IBOutlet weak var reminderNamesCollectionView: UICollectionView!
    
    // time view
    @IBOutlet weak var timeView: SoftUIView!
    @IBOutlet weak var timePickerView: SoftUIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var weekSunBtn: WeekDayPicker!
    @IBOutlet weak var weekMonBtn: WeekDayPicker!
    @IBOutlet weak var weekTueBtn: WeekDayPicker!
    @IBOutlet weak var weekWedBtn: WeekDayPicker!
    @IBOutlet weak var weekThuBtn: WeekDayPicker!
    @IBOutlet weak var weekFriBtn: WeekDayPicker!
    @IBOutlet weak var weekSatBtn: WeekDayPicker!
    @IBOutlet weak var timePickerLabel: UILabel!
    
    var reminderType: StopReminder.ReminderType = .OTHER
    
    
    
    enum CollectionViewCell: String, CollectionViewCellConfiguration {
        case itemCell = "ReminderNameCollectionViewCell"
    }
}

// MARK: - View Lifecycle
extension SetReminderPageViewController {
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.nameTextfield.delegate = self
        self.reminderNamesCollectionView.delegate = self
        self.reminderNamesCollectionView.dataSource = self
        
        self.reminderNamesCollectionView.register(CollectionViewCell.itemCell.nib, forCellWithReuseIdentifier: CollectionViewCell.itemCell.reuseId)
        self.initUI()
        self.interactor?.displayInitialState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setNameTextfield()
    }
}

// MARK:- View Display logic entry point
extension SetReminderPageViewController {
    
    func initUI(){
        self.title = "create_reminder_title".localized()
        
        self.weekSunBtn.text = "day_sun".localized()
        self.weekMonBtn.text = "day_mon".localized()
        self.weekTueBtn.text = "day_tue".localized()
        self.weekWedBtn.text = "day_wed".localized()
        self.weekThuBtn.text = "day_thu".localized()
        self.weekFriBtn.text = "day_fri".localized()
        self.weekSatBtn.text = "day_sat".localized()
        
        self.reminderNamesCollectionView.backgroundColor = UIColor.SoftUI.major
        self.reminderNamesCollectionView.clipsToBounds = false
        
        let saveBtn = UIBarButtonItem(title: "general_create".localized(), style: .plain, target: self, action: #selector(self.onSave))
        saveBtn.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = saveBtn
    }
    
    
    @objc func onSave(){
        
    }
    
    func displayCreateState(route: KmbRoute, stop: KmbStop){
        print("displayInitialState")
        
        // init soft UI
        self.initSoftUI(self.routeView)
        self.initSoftUI(self.timeView, type: .staticView)
        self.initSoftUI(self.timePickerView, inverted: true, type: .staticView)
        self.initSoftUI(self.nameView, type: .staticView)
        
        self.routeNumLabel.text = route.route
        self.routeNumLabel.useTextStyle(.header2)
        self.routeDestLabel.text = "\(route.destStop)"
        self.routeDestLabel.useTextStyle((currentLanguage != .english) ? .label_en : .label)
        self.routeOrigLabel.text = stop.name
        
        if (route.company == .KMB){
            if let image = UIImage(named: "KmbLogo") {
                self.busCompanyIcon.image = image.resized(toHeight: self.iconLayout.frame.height)
                self.busCompanyIcon.sizeToFit()
            }
        }
        
        self.timePickerLabel.text = "Please choose the notice time and period."
        self.timePickerLabel.useTextStyle(.label_sub)
        self.timePicker.datePickerMode = .time
        self.timePicker.locale = Locale(identifier: "en_GB")
        
    }
}

extension SetReminderPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ReminderTagDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SetReminderPage.DisplayItem.ViewModel.nameSamples.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.reminderNamesCollectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.itemCell.reuseId, for: indexPath) as! ReminderNameCollectionViewCell
        cell.delegate = self
        let type = SetReminderPage.DisplayItem.ViewModel.nameSamples[indexPath.row]
        cell.setInfo(type: type, selected: self.reminderType == type.type)
        cell.clipsToBounds = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func onClickTag(type: SetReminderPage.NameSample?) {
        if let type = type{
            self.reminderType = (self.reminderType == type.type) ? .OTHER : type.type
            self.reminderNamesCollectionView.reloadData()
            self.nameTextfield.text = type.name
        }
    }
}

extension SetReminderPageViewController: UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


extension SetReminderPageViewController{
    
    
    private func setNameTextfield(){
//        self.nameTextfield.enablesReturnKeyAutomatically = true
        self.nameTextfield.placeholder = "Reminder Name"
        self.nameTextfield.textColor = .darkText
        self.nameTextfield.useTextStyle(.label)
        self.nameTextfield.setLeftPaddingPoints(15)
        self.nameTextfield.setRightPaddingPoints(15)
        
        self.nameTextfield.setThemeColor(majorColor: UIColor.SoftUI.major, darkColor: UIColor.SoftUI.dark, lightColor: UIColor.SoftUI.light)
        
    }
    
    private func addShadow(_ obj: UIView, opacity: Float? = 0.7, offset: CGSize? = CGSize(width: 1, height: 1), color: CGColor? = UIColor.darkGray.cgColor){
        if let opacity = opacity, let offset = offset, let color = color {
            obj.layer.shadowOpacity = opacity
            obj.layer.shadowOffset = offset
            obj.layer.shadowColor = color
        }
    }
}
