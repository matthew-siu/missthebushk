//
//  MainPageViewController.swift
//  missthebus
//
//  Created by Matthew Siu on 6/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit
import GoogleMobileAds

// MARK: - Display logic, receive view model from presenter and present
protocol MainPageDisplayLogic: class
{
    func displayBookmarks(reminders: [MainPage.BookmarkItem])
    func updateETAs(etaList: MainPage.DisplayItem.ETAViewModel)
}

// MARK: - View Controller body
class MainPageViewController: BaseViewController, MainPageDisplayLogic
{
    // VIP
    var interactor: MainPageBusinessLogic?
    var router: (NSObjectProtocol & MainPageRoutingLogic & MainPageDataPassing)?
    
    @IBOutlet weak var stackView: UIStackView!
    // reminder label
    @IBOutlet weak var reminderImg: UIImageView!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var createReminderSoftUIView: SoftUIView!
    // no reminder view
    @IBOutlet weak var noReminderView: UIView!
    @IBOutlet weak var noReminderImg: UIImageView!
    @IBOutlet weak var noReminderLabel: UILabel!
    @IBOutlet weak var upcomingReminderView: UIView!
    // bookmark label
    @IBOutlet weak var pinImg: UIImageView!
    @IBOutlet weak var pinLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    let gradientLayer = CAGradientLayer() // TableView Faded Edges
    @IBOutlet weak var searchSoftUIView: SoftUIView! // button behaviour
    @IBOutlet weak var searchImg: UIImageView!
    
    @IBOutlet weak var adsBannerView: GADBannerView!
    @IBOutlet weak var adsBannerHeightConstraint: NSLayoutConstraint!
    
    var stopList = [KmbStop]()
    var bookmarkItems = [MainPage.BookmarkItem]()
    var etaViewModel = MainPage.DisplayItem.ETAViewModel()
    
    enum TableViewCell: String, TableViewCellConfiguration {
        case itemCell = "StopReminderTableViewCell"
        case noItemCell = "NoItemTableViewCell"
    }
}

// MARK: - View Lifecycle
extension MainPageViewController {
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = true
        self.tableView.register(TableViewCell.itemCell.nib, forCellReuseIdentifier: TableViewCell.itemCell.reuseId)
        self.tableView.register(TableViewCell.noItemCell.nib, forCellReuseIdentifier: TableViewCell.noItemCell.reuseId)
        
        self.initUI()
        self.initBanner(self.adsBannerView, heightConstaint: self.adsBannerHeightConstraint)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.interactor?.loadAllStopBookmarksOfRoute()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
        self.interactor?.dismissETATimer()
    }
    
    private func initUI(){
        
        self.title = "app_name".localized()
        
        let saveBtn = UIBarButtonItem(title: "general_setting".localized(), style: .plain, target: self, action: #selector(self.onSetting))
        saveBtn.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = saveBtn
        
        self.reminderImg.addShadow()
        self.pinImg.addShadow()
        self.reminderLabel.text = "main_upcoming_reminder".localized()
        self.pinLabel.text = "main_bookmark".localized()
        	
        // TODO:- remove: no reminder
        self.noReminderImg.image = UIImage(named: "info")
        self.noReminderImg.setImageColor(color: UIColor.MTB.darkGray)
        self.noReminderLabel.text = "main_no_upcoming_reminder".localized()
        self.noReminderLabel.textColor = UIColor.MTB.darkGray
        
        self.setSearchBtn()
        self.setCreateReminderBtn()
        self.addFadedEdgeToTableView()
    }
    
    @objc
    private func onSetting(){
        
    }
    
    func addFadedEdgeToTableView() {
        self.tableView.contentInset = UIEdgeInsets(top: 10,left: 0,bottom: 0,right: 0)
        self.gradientLayer.frame = CGRect(x: 0, y: self.stackView.frame.height + 5, width: tableView.bounds.width, height: 35.0)
        self.gradientLayer.colors = [UIColor.SoftUI.major.cgColor, UIColor.SoftUI.major.withAlphaComponent(0).cgColor]
        self.stackView.layer.addSublayer(self.gradientLayer)
    }
    
    private func setCreateReminderBtn(){
        self.createReminderSoftUIView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.createReminderSoftUIView.cornerRadius = 50
        self.createReminderSoftUIView.shadowOffset = .init(width: 5, height: 5)
        self.createReminderSoftUIView.shadowOpacity = 0.5
        self.createReminderSoftUIView.addTarget(self, action: #selector(self.goToCreateReminderPage), for: .touchUpInside)
    }
    
    private func setSearchBtn(){
        self.searchSoftUIView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.searchSoftUIView.cornerRadius = 50
        self.searchSoftUIView.shadowOffset = .init(width: 5, height: 5)
        self.searchSoftUIView.shadowOpacity = 0.5
        self.searchImg.addShadow()
        self.searchSoftUIView.addTarget(self, action: #selector(self.goToSearchPage), for: .touchUpInside)

    }
    
    @objc private func goToCreateReminderPage(){
        self.router?.routeToCreateReminderPage()
    }
    
    @objc
    private func goToSearchPage(_: AnyObject){
        self.router?.routeToSearchPage()
    }
}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource, StopReminderCellDelegate{
    func onSelect(_ index: Int) {
        if (index >= 0){
            print("onSelect")
            self.router?.routeToStopListPage(item: self.bookmarkItems[index])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.bookmarkItems.count == 0) ? 1 : self.bookmarkItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.bookmarkItems.count == 0){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.noItemCell.reuseId, for: indexPath) as! NoItemTableViewCell
            cell.setInfo(UIImage(named: "info"),
                         "main_no_bookmark".localized())
            cell.backgroundColor = .none
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.itemCell.reuseId, for: indexPath) as! StopReminderTableViewCell
            let bookmarkItem = self.bookmarkItems[indexPath.row]
            let etaItem = self.etaViewModel.etaList.first(where: {$0.stopId == bookmarkItem.stopId})
            cell.setInfo(stop: bookmarkItem, etaItem: etaItem)
            cell.delegate = self
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.bookmarkItems.count != 0){
            print("did select")
            self.router?.routeToStopListPage(item: self.bookmarkItems[indexPath.row])
        }
    }
    
}

// MARK:- View Display logic entry point
extension MainPageViewController {
    func displayBookmarks(reminders: [MainPage.BookmarkItem]){
        self.bookmarkItems = reminders
        print("# bookmark = \(self.bookmarkItems.count)")
        self.tableView.reloadData()
    }
    
    func updateETAs(etaList: MainPage.DisplayItem.ETAViewModel){
        print("update ETA: \(etaList.etaList.count)")
        self.etaViewModel = etaList
        self.tableView.reloadData()
    }
}
