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
    func displayReminders(reminders: [MainPage.BookmarkItem])
    func updateETAs(etaList: MainPage.DisplayItem.ETAViewModel)
}

// MARK: - View Controller body
class MainPageViewController: BaseViewController, MainPageDisplayLogic
{
    // VIP
    var interactor: MainPageBusinessLogic?
    var router: (NSObjectProtocol & MainPageRoutingLogic & MainPageDataPassing)?
    
    @IBOutlet weak var searchSoftUIView: SoftUIView! // button behaviour
    @IBOutlet weak var searchImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reminderImg: UIImageView!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var pinImg: UIImageView!
    @IBOutlet weak var pinLabel: UILabel!
    
    @IBOutlet weak var adsBannerView: GADBannerView!
    
    var stopList = [KmbStop]()
    var bookmarkItems = [MainPage.BookmarkItem]()
    var etaViewModel = MainPage.DisplayItem.ETAViewModel()
    
    enum TableViewCell: String, TableViewCellConfiguration {
        case itemCell = "StopReminderTableViewCell"
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
        
        self.initUI()
        self.initBanner(self.adsBannerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.interactor?.loadAllStopRemindersOfRoute()
        
    }
    
    private func initUI(){
        
        let saveBtn = UIBarButtonItem(title: "setting".localized(), style: .plain, target: self, action: #selector(self.onSetting))
        saveBtn.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = saveBtn
        
        self.reminderImg.tintColor = UIColor.darkGrey
        self.pinImg.tintColor = UIColor.darkGrey
        
        self.setSearchBtn()
    }
    
    @objc
    private func onSetting(){
        
    }
    
    private func setSearchBtn(){
        self.searchSoftUIView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        self.searchSoftUIView.cornerRadius = 50
        self.searchSoftUIView.shadowOffset = .init(width: 5, height: 5)
        self.searchSoftUIView.shadowOpacity = 0.5
        self.searchImg.addShadow()
        self.searchSoftUIView.addTarget(self, action: #selector(goToSearchPage), for: .touchUpInside)

    }
    
    @objc
    private func goToSearchPage(_: AnyObject){
        self.router?.routeToSearchPage()
    }
}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource, StopReminderCellDelegate{
    func onSelect(_ index: Int) {
        if (index >= 0){
            
            self.router?.routeToStopListPage(item: self.bookmarkItems[index])
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.bookmarkItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.itemCell.reuseId, for: indexPath) as! StopReminderTableViewCell

        let bookmarkItem = self.bookmarkItems[indexPath.row]
        let etaItem = self.etaViewModel.etaList.first(where: {$0.stopId == bookmarkItem.stopId})
        cell.setInfo(stop: bookmarkItem, etaItem: etaItem)
        cell.delegate = self
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        self.router?.routeToStopListPage(item: self.bookmarkItems[indexPath.row])
    }
    
}

// MARK:- View Display logic entry point
extension MainPageViewController {
    func displayReminders(reminders: [MainPage.BookmarkItem]){
        self.bookmarkItems = reminders
        print("# reminder = \(self.bookmarkItems.count)")
        self.tableView.reloadData()
    }
    
    func updateETAs(etaList: MainPage.DisplayItem.ETAViewModel){
        print("update ETA: \(etaList.etaList.count)")
        self.etaViewModel = etaList
        self.tableView.reloadData()
    }
}
