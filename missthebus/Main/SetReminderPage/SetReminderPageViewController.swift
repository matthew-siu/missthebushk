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
    func updateRouteAndStop(viewModel: SetReminderPage.DisplayItem.RouteAndStopViewModel)
}

// MARK: - View Controller body
class SetReminderPageViewController: BaseViewController, SetReminderPageDisplayLogic
{
    // VIP
    var interactor: SetReminderPageBusinessLogic?
    var router: (NSObjectProtocol & SetReminderPageRoutingLogic & SetReminderPageDataPassing)?
    
    // scroll view
    @IBOutlet weak var contentView: UIView!
    
    // name view
    @IBOutlet weak var nameView: SoftUIView!
    @IBOutlet weak var reminderIcon: UIImageView!
    @IBOutlet weak var nameTextfield: SoftUITextfield!
    @IBOutlet weak var reminderNamesCollectionView: UICollectionView!
    
    // time view
    @IBOutlet weak var timeView: SoftUIView!
    @IBOutlet weak var timePickerView: SoftUIView!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var weekSunBtn: WeekDayPicker! // 0
    @IBOutlet weak var weekMonBtn: WeekDayPicker! // 1
    @IBOutlet weak var weekTueBtn: WeekDayPicker!
    @IBOutlet weak var weekWedBtn: WeekDayPicker!
    @IBOutlet weak var weekThuBtn: WeekDayPicker!
    @IBOutlet weak var weekFriBtn: WeekDayPicker!
    @IBOutlet weak var weekSatBtn: WeekDayPicker! // 6
    @IBOutlet weak var timePickerLabel: UILabel!
    
    // add routes view
    @IBOutlet weak var addRouteBtn: SoftUIView!
    @IBOutlet weak var addRouteLabel: UILabel!
    
    // route and stop table view
    @IBOutlet weak var tableView: UITableView!
    
    
    var reminderType: StopReminder.ReminderType = .OTHER
    var daysOfWeekList = [WeekDayPicker]()
    var getRouteStopResponse: SetReminderPage.GetRouteStopResponse?
    var routes = [SetReminderPage.RouteAndStop]()
    
    enum CollectionViewCell: String, CollectionViewCellConfiguration {
        case itemCell = "ReminderNameCollectionViewCell"
    }
    enum TableViewCell: String, TableViewCellConfiguration {
        case itemCell = "ReminderRouteTableViewCell"
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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.reminderNamesCollectionView.register(CollectionViewCell.itemCell.nib, forCellWithReuseIdentifier: CollectionViewCell.itemCell.reuseId)
        self.tableView.register(TableViewCell.itemCell.nib, forCellReuseIdentifier: TableViewCell.itemCell.reuseId)
        self.daysOfWeekList = [self.weekSunBtn, self.weekMonBtn, self.weekTueBtn, self.weekWedBtn, self.weekThuBtn, self.weekFriBtn, self.weekSatBtn]
        self.initUI()
        self.interactor?.displayInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        if let resp = self.getRouteStopResponse {
            print("resp: \(resp.routeNum) | \(resp.stopSeqList)")
            self.interactor?.getRouteStopResponse(resp: resp)
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
        self.tableView.backgroundColor = UIColor.SoftUI.major
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
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
        self.initSoftUI(self.timeView, type: .staticView)
        self.initSoftUI(self.timePickerView, inverted: true, type: .staticView)
        self.initSoftUI(self.nameView, type: .staticView)
        self.initSoftUI(self.addRouteBtn)
        
        self.reminderIcon.image = UIImage(named: self.getIconNameFromNameSampleList(type: viewModel.reminderType))
        self.reminderIcon.addShadow()
        
        self.timePickerLabel.text = "reminder_time_label".localized()
        self.timePickerLabel.useTextStyle(.label_sub)
        self.startTimePicker.datePickerMode = .time
        self.startTimePicker.locale = Locale(identifier: "en_GB")
        self.endTimePicker.datePickerMode = .time
        self.endTimePicker.locale = Locale(identifier: "en_GB")
        
        self.addRouteLabel.text = "reminder_add_stop".localized() + " (0/5)"
        self.addRouteLabel.useTextStyle(.label_sub)
        self.addRouteBtn.addTarget(self, action: #selector(addNewRouteStop), for: .touchUpInside)
        
        
    }
    
    @objc private func addNewRouteStop(){
        print("addNewRouteStop")
        self.router?.routeToSearchPage()
    }
    
    func updateRouteAndStop(viewModel: SetReminderPage.DisplayItem.RouteAndStopViewModel){
        print("updateRouteAndStop")
        self.routes = viewModel.routes
        self.tableView.reloadData()
    }
}

extension SetReminderPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: TableViewCell.itemCell.reuseId, for: indexPath) as! ReminderRouteTableViewCell
        cell.setInfo(self.routes[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
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
        let data = SetReminderPage.DisplayItem.Request(reminderName: name, reminderType: self.reminderType, time: self.startTimePicker.date, period: period)
        self.interactor?.saveReminder(request: data)
        
        
        self.showAlert("general_saved".localized(), "reminder_create_succeed".localized()) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
