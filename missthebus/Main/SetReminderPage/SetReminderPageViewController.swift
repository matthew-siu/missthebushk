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
    func displayCreateState(viewModel: SetReminderPage.DisplayItem.ViewModel)
}

// MARK: - View Controller body
class SetReminderPageViewController: BaseViewController, SetReminderPageDisplayLogic
{
    // VIP
    var interactor: SetReminderPageBusinessLogic?
    var router: (NSObjectProtocol & SetReminderPageRoutingLogic & SetReminderPageDataPassing)?
    
    // route view
    @IBOutlet weak var routeView: SoftUIView!
    
    @IBOutlet weak var routeStopView: UIStackView!
    @IBOutlet weak var routeNumLabel: UILabel!
    @IBOutlet weak var busCompanyIcon: UIImageView!
    @IBOutlet weak var iconLayout: UIView!
    @IBOutlet weak var routeDestLabel: UILabel!
    @IBOutlet weak var routeOrigLabel: UILabel!
    // select route view
    @IBOutlet weak var selectStopView: UIView!
    @IBOutlet weak var selectStopLabel: UILabel!
    
    // name view
    @IBOutlet weak var nameView: SoftUIView!
    @IBOutlet weak var reminderIcon: UIImageView!
    @IBOutlet weak var nameTextfield: SoftUITextfield!
    @IBOutlet weak var reminderNamesCollectionView: UICollectionView!
    
    // time view
    @IBOutlet weak var timeView: SoftUIView!
    @IBOutlet weak var timePickerView: SoftUIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var weekSunBtn: WeekDayPicker! // 0
    @IBOutlet weak var weekMonBtn: WeekDayPicker! // 1
    @IBOutlet weak var weekTueBtn: WeekDayPicker!
    @IBOutlet weak var weekWedBtn: WeekDayPicker!
    @IBOutlet weak var weekThuBtn: WeekDayPicker!
    @IBOutlet weak var weekFriBtn: WeekDayPicker!
    @IBOutlet weak var weekSatBtn: WeekDayPicker! // 6
    @IBOutlet weak var timePickerLabel: UILabel!
    
    var reminderType: StopReminder.ReminderType = .OTHER
    var daysOfWeekList = [WeekDayPicker]()
    var selectedStop: KmbRouteStop?
    
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
        self.daysOfWeekList = [self.weekSunBtn, self.weekMonBtn, self.weekTueBtn, self.weekWedBtn, self.weekThuBtn, self.weekFriBtn, self.weekSatBtn]
        self.initUI()
        self.interactor?.displayInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        if let routeStop = self.selectedStop {
            print("succeed!!!")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setNameTextfield()
    }
}

// MARK:- View Display logic entry point
extension SetReminderPageViewController {
    
    func initUI(){
        
        self.weekSunBtn.text = "day_sun".localized()
        self.weekMonBtn.text = "day_mon".localized()
        self.weekTueBtn.text = "day_tue".localized()
        self.weekWedBtn.text = "day_wed".localized()
        self.weekThuBtn.text = "day_thu".localized()
        self.weekFriBtn.text = "day_fri".localized()
        self.weekSatBtn.text = "day_sat".localized()
        
        self.reminderNamesCollectionView.backgroundColor = UIColor.SoftUI.major
        self.reminderNamesCollectionView.clipsToBounds = false
    }
    
    
    @objc func onSave(){
//        self.saveReminder()
    }
    
    func displayCreateState(viewModel: SetReminderPage.DisplayItem.ViewModel){
        
        // nav bar
        self.title = (viewModel.mode == .CREATE) ? "create_reminder_title".localized() : "update_reminder_title".localized()
        
        let saveBtn = UIBarButtonItem(title: (viewModel.mode == .CREATE) ? "general_create".localized() : "general_update".localized(), style: .plain, target: self, action: #selector(self.onSave))
        saveBtn.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = saveBtn
        
        // init soft UI
        self.initSoftUI(self.routeView)
        self.initSoftUI(self.timeView, type: .staticView)
        self.initSoftUI(self.timePickerView, inverted: true, type: .staticView)
        self.initSoftUI(self.nameView, type: .staticView)
        
        self.routeStopView.isHidden = (viewModel.mode == .CREATE)
        self.routeNumLabel.isHidden = (viewModel.mode == .CREATE)
        self.selectStopView.isHidden = (viewModel.mode == .UPDATE)
        if (viewModel.mode == .UPDATE){
            self.reminderIcon.image = UIImage(named: self.getIconNameFromNameSampleList(type: viewModel.reminderType))
            self.reminderIcon.addShadow()
            self.routeNumLabel.text = String(viewModel.routeNum)
            self.routeNumLabel.useTextStyle(.header2)
            self.routeDestLabel.text = viewModel.destStopName
            self.routeDestLabel.useTextStyle((currentLanguage != .english) ? .label_en : .label)
            self.routeOrigLabel.text = viewModel.currentStopName
            if (viewModel.busCompany == .KMB){
                if let image = UIImage(named: "KmbLogo") {
                    self.busCompanyIcon.image = image.resized(toHeight: self.iconLayout.frame.height)
                    self.busCompanyIcon.sizeToFit()
                }
            }
        }else{
            self.selectStopLabel.text = "reminder_add_stop".localized()
            self.selectStopLabel.useTextStyle(.label_sub)
            self.routeView.addTarget(self, action: #selector(self.addNewRouteStop), for: .touchUpInside)
        }
        
        self.timePickerLabel.text = "reminder_time_label".localized()
        self.timePickerLabel.useTextStyle(.label_sub)
        self.timePicker.datePickerMode = .time
        self.timePicker.locale = Locale(identifier: "en_GB")
        
    }
    
    @objc private func addNewRouteStop(){
        print("addNewRouteStop")
        self.router?.routeToSearchPage()
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
    
    // ReminderTagDelegate
    func onClickTag(type: SetReminderPage.NameSample?) {
        if let type = type{
            self.reminderType = (self.reminderType == type.type) ? .OTHER : type.type
            self.reminderNamesCollectionView.reloadData()
            self.nameTextfield.text = type.name
            self.reminderIcon.image = UIImage(named: type.img)
        }
    }
}

extension SetReminderPageViewController: UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// logic
extension SetReminderPageViewController{
    
    private func getIconNameFromNameSampleList(type: StopReminder.ReminderType) -> String{
        let imgName = SetReminderPage.DisplayItem.ViewModel.nameSamples.first(where: {$0.type == self.reminderType})?.img
        return imgName ?? "tagOther"
    }
    
    private func setNameTextfield(){
//        self.nameTextfield.enablesReturnKeyAutomatically = true
        self.nameTextfield.placeholder = "reminder_name".localized()
        self.nameTextfield.textColor = .darkText
        self.nameTextfield.useTextStyle(.label)
        self.nameTextfield.setLeftPaddingPoints(15)
        self.nameTextfield.setRightPaddingPoints(15)
        
        self.nameTextfield.setThemeColor(majorColor: UIColor.SoftUI.major, darkColor: UIColor.SoftUI.dark, lightColor: UIColor.SoftUI.light)
        
    }
    
    private func saveReminder(){
        
        var period = [Int]()
        for (index, day) in self.daysOfWeekList.enumerated() {
            if (day.isSelected){
                period.append(index)
            }
        }
        var name = self.nameTextfield.text ?? ""
        if (name.count == 0){
            name = SetReminderPage.DisplayItem.ViewModel.nameSamples.first(where: {$0.type == self.reminderType})?.name ?? "reminder_tag_other".localized()
        }
        let data = SetReminderPage.DisplayItem.Request(reminderName: name, reminderType: self.reminderType, time: self.timePicker.date, period: period)
        self.interactor?.saveReminder(request: data)
        
        
        self.showAlert("general_saved".localized(), "reminder_create_succeed".localized()) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
