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
    func displayUpdateState(viewModel: SetReminderPage.DisplayItem.ViewModel)
    func updateRouteAndStop(viewModel: SetReminderPage.DisplayItem.RouteAndStopViewModel)
}

// MARK: - View Controller body
class SetReminderPageViewController: BaseViewController, SetReminderPageDisplayLogic
{
    // VIP
    var interactor: SetReminderPageBusinessLogic?
    var router: (NSObjectProtocol & SetReminderPageRoutingLogic & SetReminderPageDataPassing)?
    
    // scroll view
    @IBOutlet weak var scrollView: UIScrollView!
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
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    var viewContentHeight: CGFloat{
        return self.height - (self.navigationController?.navigationBar.frame.height ?? 0) - (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + 1
//        return self.addRouteBtn.frame.maxY + self.tableView.contentSize.height
    }
    
    var mode: SetReminderPage.Mode = .CREATE
    var reminderType: StopReminder.ReminderType = .OTHER
    var daysOfWeekList = [WeekDayPicker]()
    var getRouteStopResponse: StopListPage.Service.Response.GetRouteStops?
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
        self.tableView.dragInteractionEnabled = true
        self.tableView.dragDelegate = self
        self.tableView.allowsSelection = true
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        
        self.reminderNamesCollectionView.register(CollectionViewCell.itemCell.nib, forCellWithReuseIdentifier: CollectionViewCell.itemCell.reuseId)
        self.daysOfWeekList = [self.weekSunBtn, self.weekMonBtn, self.weekTueBtn, self.weekWedBtn, self.weekThuBtn, self.weekFriBtn, self.weekSatBtn]
        self.initUI()
        self.interactor?.displayInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let resp = self.getRouteStopResponse {
            print("resp: \(resp.route.route) | \(resp.stops)")
            self.interactor?.getRouteStopResponse(resp: resp)
            self.getRouteStopResponse = nil
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setNameTextfield()
        
    }
    
    private func autoExpand(){
        self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if (self.tableView.frame.maxY < self.viewContentHeight){
                self.scrollView.frame.size = CGSize(width: self.width, height: self.viewContentHeight)
            }else{
                self.scrollView.frame.size = CGSize(width: self.width, height: self.tableView.frame.maxY)
            }
            
//            print("autoExpand after:  scrollview: \(self.scrollView.frame.height) / \(self.scrollView.contentSize.height) | table real height: \(self.tableView.contentSize.height) | ui height: \(self.tableView.frame.height) | table maxY: \(self.tableView.frame.minY) - \(self.tableView.frame.maxY)")

        }
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
        self.tableView.register(TableViewCell.itemCell.nib, forCellReuseIdentifier: TableViewCell.itemCell.reuseId)
        
        
        // init soft UI
        self.initSoftUI(self.timeView, type: .staticView)
        self.initSoftUI(self.timePickerView, inverted: true, type: .staticView)
        self.initSoftUI(self.nameView, type: .staticView)
        self.initSoftUI(self.addRouteBtn)
        
        
        self.timePickerLabel.text = "reminder_time_label".localized()
        self.timePickerLabel.useTextStyle(.label_sub)
        self.startTimePicker.datePickerMode = .time
        self.startTimePicker.locale = Locale(identifier: "en_GB")
        
        self.addRouteLabel.useTextStyle(.label_sub)
        self.addRouteBtn.addTarget(self, action: #selector(self.addNewRouteStop), for: .touchUpInside)
    }
    
    
    @objc func onSave(){
        self.saveReminder()
    }
    
    func displayCreateState(viewModel: SetReminderPage.DisplayItem.ViewModel){
        self.mode = .CREATE
        // nav bar
        self.title = "create_reminder_title".localized()
        
        let saveBtn = UIBarButtonItem(title: "general_create".localized(), style: .plain, target: self, action: #selector(self.onSave))
        saveBtn.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = saveBtn
        
        self.reminderIcon.image = UIImage(named: self.getIconNameFromNameSampleList(type: viewModel.reminderType))
        self.reminderIcon.addShadow()
        
        self.addRouteLabel.text = "reminder_add_stop".localized() + " (\(self.routes.count)/5)"
        
        
        self.tableViewHeightConstraint.constant = 50
    }
    
    func displayUpdateState(viewModel: SetReminderPage.DisplayItem.ViewModel){
        self.mode = .UPDATE
        // nav bar
        self.reminderType = viewModel.reminderType
        self.title = "update_reminder_title".localized()
        
        let saveBtn = UIBarButtonItem(title: "general_save".localized(), style: .plain, target: self, action: #selector(self.onSave))
        saveBtn.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = saveBtn
        
        self.reminderIcon.image = UIImage(named: self.getIconNameFromNameSampleList(type: viewModel.reminderType))
        self.reminderIcon.addShadow()
        self.nameTextfield.text = viewModel.name
        self.startTimePicker.date = viewModel.time ?? Date()
        if let period = viewModel.period{
            for day in period{
                self.daysOfWeekList[day].select()
            }
        }
        self.addRouteLabel.text = "reminder_add_stop".localized() + " (\(self.routes.count)/5)"
    }
    
//    @objc private func onDateValueChanged(){
//
//    }
    
    @objc private func addNewRouteStop(){
        print("addNewRouteStop")
        if (self.routes.count >= 5){
            self.showAlert("general_remind".localized(), "reminder_err_at_most_route".localized()) { (_) in}
        }else{
            self.router?.routeToSearchPage()
        }
        
    }
    
    func updateRouteAndStop(viewModel: SetReminderPage.DisplayItem.RouteAndStopViewModel){
        self.routes = viewModel.routes
        self.addRouteLabel.text = "reminder_add_stop".localized() + " (\(self.routes.count)/5)"
        self.tableView.reloadData{
            self.autoExpand()
        }
    }
}

extension SetReminderPageViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: TableViewCell.itemCell.reuseId, for: indexPath) as! ReminderRouteTableViewCell
        cell.setInfo(self.routes[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // on delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.routes.remove(at: indexPath.row)
            self.interactor?.removeRouteStop(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.router?.routeToStopListPage(index: indexPath.row)
    }
    
    // on drag & drop
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = self.routes[indexPath.row]
        return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = self.routes.remove(at: sourceIndexPath.row)
        self.routes.insert(mover, at: destinationIndexPath.row)
        self.interactor?.rearrangeReminder(at: sourceIndexPath.row, to: destinationIndexPath.row)
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
            if (self.nameTextfield.text?.count == 0 || SetReminderPage.DisplayItem.ViewModel.nameSamples.contains(where: {$0.name.lowercased() == self.nameTextfield.text?.lowercased()})){
                self.nameTextfield.text = type.name
            }
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
        let imgName = SetReminderPage.DisplayItem.ViewModel.nameSamples.first(where: {$0.type == type})?.img
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
        if (self.routes.count == 0){
            self.showAlert("general_remind".localized(), "reminder_err_at_least_route".localized()) { (_) in}
            return
        }
        
        var period = [Int]()
        for (index, day) in self.daysOfWeekList.enumerated() {
            if (day.isSelected){
                period.append(index)
            }
        }
        if (period.count == 0){
            self.showAlert("general_remind".localized(), "reminder_err_day_of_week".localized()) { (_) in}
        }
        var name = self.nameTextfield.text ?? ""
        if (name.count == 0){
            name = SetReminderPage.DisplayItem.ViewModel.nameSamples.first(where: {$0.type == self.reminderType})?.name ?? "reminder_tag_other".localized()
        }
        let data = SetReminderPage.DisplayItem.Request(reminderName: name, reminderType: self.reminderType, time: self.startTimePicker.date, period: period)
        self.interactor?.saveReminder(request: data)
        
        let msg = (self.mode == .CREATE) ? "reminder_create_succeed".localized() : "reminder_update_succeed".localized()
        self.showAlert("general_saved".localized(), msg) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
