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
    func displayBookmarks(viewModel: MainPage.DisplayItem.Bookmarks.ViewModel)
    func displayReminders(viewModel: MainPage.DisplayItem.Reminders.ViewModel)
    func displayUpcoming(viewModel: MainPage.DisplayItem.UpcomingReminders.ViewModel)
    func updateETAs(etaList: MainPage.DisplayItem.Bookmarks.ETAViewModel)
}

// MARK: - View Controller body
class MainPageViewController: BaseViewController, MainPageDisplayLogic
{
    // VIP
    var interactor: MainPageBusinessLogic?
    var router: (NSObjectProtocol & MainPageRoutingLogic & MainPageDataPassing)?
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var upcomingTabBarItem: UITabBarItem!
    @IBOutlet weak var bookmarksTabBarItem: UITabBarItem!
    @IBOutlet weak var remindersTabBarItem: UITabBarItem!
    @IBOutlet weak var searchTabBarItem: UITabBarItem!
    var createBtn = UIBarButtonItem()
    
    @IBOutlet weak var tableView: UITableView!
    let gradientLayer = CAGradientLayer() // TableView Faded Edges
    
    
    @IBOutlet weak var adsBannerView: GADBannerView!
    @IBOutlet weak var adsBannerHeightConstraint: NSLayoutConstraint!
    
    var stopList = [Stop]()
    var basicViewModel = MainPage.BasicViewModel(headerImgName: "", headerLabel: "")
    var currentTab: MainPage.Tab = .Bookmarks
    // my bookmarks viewModel
    var bookmarkItems = [MainPage.BookmarkItem]()
    var bookmarkETAViewModel = MainPage.DisplayItem.Bookmarks.ETAViewModel()
    // my reminders vireModel
    var reminderItems = [MainPage.ReminderItem]()
    // my upcoming reminders vireModel
    var upcomingReminderItem: MainPage.UpcomingReminderItem?
    
    enum TableViewCell: String, TableViewCellConfiguration {
        case bookMarkItemCell = "StopBookmarkTableViewCell"
        case reminderItemCell = "SimpleStopReminderTableViewCell"
        case upcomingItemCell = "UpcomingStopReminderTableViewCell"
        case noItemCell = "NoItemTableViewCell"
        case upcomingHeader = "UpcomingStopReminderHeaderView"
    }
}

// MARK: - View Lifecycle
extension MainPageViewController {
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.dragInteractionEnabled = true
        self.tableView.dragDelegate = self
        self.tableView.allowsSelection = true
        self.tableView.separatorStyle = .none
        self.tableView.register(TableViewCell.bookMarkItemCell.nib, forCellReuseIdentifier: TableViewCell.bookMarkItemCell.reuseId)
        self.tableView.register(TableViewCell.reminderItemCell.nib, forCellReuseIdentifier: TableViewCell.reminderItemCell.reuseId)
        self.tableView.register(TableViewCell.upcomingItemCell.nib, forCellReuseIdentifier: TableViewCell.upcomingItemCell.reuseId)
        self.tableView.register(TableViewCell.noItemCell.nib, forCellReuseIdentifier: TableViewCell.noItemCell.reuseId)
        self.tableView.register(TableViewCell.upcomingHeader.nib, forHeaderFooterViewReuseIdentifier: TableViewCell.upcomingHeader.reuseId)
        
        self.tabBar.delegate = self
        
        self.initUI()
        self.initBanner(self.adsBannerView, heightConstaint: self.adsBannerHeightConstraint)
        
        self.interactor?.loadFirstTab()
            .done{result in
                self.currentTab = result
                self.initTab()
            }.catch{_ in
                self.currentTab = .Bookmarks
                self.initTab()
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.interactor?.dismissETATimer()
    }
    
    private func initTab(){
        
        switch self.currentTab{
            case .Bookmarks:
                self.interactor?.loadAllBookmarksOfRoute()
                self.tabBar.selectedItem = self.bookmarksTabBarItem
                return
            case .Reminders:
                self.interactor?.loadAllRemindersOfRoute()
                self.tabBar.selectedItem = self.remindersTabBarItem
                return
            case .Upcoming:
                self.interactor?.loadOneUpcomingReminder()
                self.tabBar.selectedItem = self.upcomingTabBarItem
                return
            case .Search: return
        }
    }
    
    private func initUI(){
        
        self.title = "app_name".localized()
        self.view.backgroundColor = UIColor.SoftUI.major
        
        let settingBtn = UIBarButtonItem(title: "general_setting".localized(), style: .plain, target: self, action: #selector(self.onClickSetting))
        settingBtn.tintColor = .systemBlue
        self.navigationItem.leftBarButtonItem = settingBtn
        
        createBtn = UIBarButtonItem(title: "general_create".localized(), style: .plain, target: self, action: #selector(self.onClickCreate))
        createBtn.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = createBtn
        
        self.tabBar.barTintColor = UIColor.SoftUI.major
        self.upcomingTabBarItem.title = MainPage.DisplayItem.TabBarItems.upcoming.localized()
        self.bookmarksTabBarItem.title = MainPage.DisplayItem.TabBarItems.bookmarks.localized()
        self.remindersTabBarItem.title = MainPage.DisplayItem.TabBarItems.reminders.localized()
        self.searchTabBarItem.title = MainPage.DisplayItem.TabBarItems.search.localized()
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        self.tableView.backgroundColor = UIColor.SoftUI.major
        
//        self.addFadedEdgeToTableView()
    }
    
    @objc
    private func onClickSetting(){
        self.router?.routeToSettingPage()
    }
    
    @objc private func onClickCreate(){
        if (self.currentTab == .Bookmarks){
            self.router?.routeToSearchPage()
        }else if (self.currentTab == .Reminders){
            self.router?.routeToCreateReminderPage()
        }
    }
    
    func addFadedEdgeToTableView() {
        self.gradientLayer.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 35.0)
        self.gradientLayer.colors = [UIColor.SoftUI.major.cgColor, UIColor.SoftUI.major.withAlphaComponent(0).cgColor]
        self.tableView.layer.addSublayer(self.gradientLayer)
    }
    
}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, StopBookmarkCellDelegate, StopReminderCellDelegate{
    // StopReminderCellDelegate
    func onSelectStopBookmarkCell(_ index: Int) {
        if (index >= 0){
            print("on select #\(index)")
            self.router?.routeToStopListPage(item: self.bookmarkItems[index])
        }
    }
    
    func onSelectStopReminderCell(_ index: Int){
        if (index >= 0){
            self.router?.routeToUpdateReminderPage(index: index)
        }
    }
    
    // header view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (self.currentTab == .Upcoming && self.upcomingReminderItem != nil){
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewCell.upcomingHeader.reuseId) as! UpcomingStopReminderHeaderView
            headerView.delegate = self
            headerView.setContent(reminder: self.upcomingReminderItem?.header)
            headerView.contentView.backgroundColor = UIColor.SoftUI.major
            return headerView
        }else{
            let headerView = MainPageHeaderView(frame: .init(x: 0, y: 0, width: self.width, height: 40))
            headerView.setContent(imgName: self.basicViewModel.headerImgName, title: self.basicViewModel.headerLabel)
            return headerView
        }
    }
    
    // header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (self.currentTab == .Upcoming) {
            return (self.upcomingReminderItem != nil) ? 150 : 40
        } else{
            return 40
        }
    }
    
    // number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.currentTab == .Bookmarks){
            
            return (self.bookmarkItems.count == 0) ? 1 : self.bookmarkItems.count
        }else if (self.currentTab == .Reminders){
            return (self.reminderItems.count == 0) ? 1 : self.reminderItems.count
        }else if (self.currentTab == .Upcoming){
            return self.upcomingReminderItem?.routes.count ?? 1
        }
        return 0
    }
    
    // table view cell body
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.currentTab == .Bookmarks){
            
            if (self.bookmarkItems.count > 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.bookMarkItemCell.reuseId, for: indexPath) as! StopBookmarkTableViewCell
                let bookmarkItem = self.bookmarkItems[indexPath.row]
                let etaItem = self.bookmarkETAViewModel.etaList.first(where: {$0.company == bookmarkItem.company && $0.stopId == bookmarkItem.stopId && $0.route == bookmarkItem.routeMetadata})
                cell.setInfo(index: indexPath.row, stop: bookmarkItem, etaItem: etaItem)
                cell.delegate = self
                cell.backgroundColor = .none
                cell.selectionStyle = .none
                return cell
            }
        }else if (self.currentTab == .Reminders){
            if (self.reminderItems.count > 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reminderItemCell.reuseId, for: indexPath) as! SimpleStopReminderTableViewCell
                let reminderItem = self.reminderItems[indexPath.row]
                cell.setInfo(index: indexPath.row, viewModel: reminderItem)
                cell.delegate = self
                cell.backgroundColor = .none
                cell.selectionStyle = .none
                return cell
            }
        }else if (self.currentTab == .Upcoming){
            if let _ = self.upcomingReminderItem{
                let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.upcomingItemCell.reuseId, for: indexPath) as! UpcomingStopReminderTableViewCell
                if let route = self.upcomingReminderItem?.routes[indexPath.row]{
                    let etaList = self.bookmarkETAViewModel.etaList.filter({$0.company == route.company && $0.route == route.route})
                    cell.setInfo(viewModel: self.upcomingReminderItem?.routes[indexPath.row], etaList: etaList)
                }
                cell.backgroundColor = .none
                cell.selectionStyle = .none
                return cell
            }
        }
        // else: no item in the table
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.noItemCell.reuseId, for: indexPath) as! NoItemTableViewCell
        cell.setInfo(UIImage(named: "info"),
                     self.basicViewModel.noItemLabel)
        cell.backgroundColor = .none
        cell.selectionStyle = .none
        return cell
        
    }
    
    // on delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if (self.currentTab == .Bookmarks){
                self.bookmarkItems.remove(at: indexPath.row)
                self.interactor?.removeBookmark(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }else if (self.currentTab == .Reminders){
                self.reminderItems.remove(at: indexPath.row)
                self.interactor?.removeReminder(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    // on drag
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        if (self.currentTab == .Bookmarks){
            dragItem.localObject = self.bookmarkItems[indexPath.row]
            return [dragItem]
        }else if (self.currentTab == .Reminders){
            dragItem.localObject = self.reminderItems[indexPath.row]
            return [dragItem]
        }else{
            return [UIDragItem]()
        }
    }
    
    // on drop
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if (sourceIndexPath.row != destinationIndexPath.row){
            if (self.currentTab == .Bookmarks){
                let mover = self.bookmarkItems.remove(at: sourceIndexPath.row)
                self.bookmarkItems.insert(mover, at: destinationIndexPath.row)
                self.interactor?.rearrangeBookmark(at: sourceIndexPath.row, to: destinationIndexPath.row)
            }else if (self.currentTab == .Reminders){
                let mover = self.reminderItems.remove(at: sourceIndexPath.row)
                self.reminderItems.insert(mover, at: destinationIndexPath.row)
                self.interactor?.rearrangeReminder(at: sourceIndexPath.row, to: destinationIndexPath.row)
            }
            self.tableView.reloadData()
        }
    }
    
}

extension MainPageViewController: ShowUpcomingNotiDelegate{
    func onClickShowUpcomingNoti() {
        self.createNotification()
    }
    
    
    func createNotification(){
        DispatchQueue.main.async {
            if let content = self.interactor?.createNotificationContent(etaVM: self.bookmarkETAViewModel){
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)

                let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                    DispatchQueue.main.async {
                        self.showToast(message: "general_done".localized())
                    }
                })
            }
            
        }
    }
    
}


// MARK: - On TabBarItem Click
extension MainPageViewController: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        Log.d(.RUNTIME, "onTab")
        if (item == self.bookmarksTabBarItem && self.currentTab != .Bookmarks){
            self.interactor?.changeToTab(at: MainPage.Tab.Bookmarks.rawValue)
        }else if (item == self.remindersTabBarItem && self.currentTab != .Reminders){
            self.interactor?.changeToTab(at: MainPage.Tab.Reminders.rawValue)
        }else if (item == self.upcomingTabBarItem && self.currentTab != .Upcoming){
            self.interactor?.changeToTab(at: MainPage.Tab.Upcoming.rawValue)
            self.currentTab = .Upcoming
            self.tableView.reloadData()
        }else if (item == self.searchTabBarItem){
            self.router?.routeToSearchPage()
        }
    }
}

// MARK:- View Display logic entry point
extension MainPageViewController {
    func displayBookmarks(viewModel: MainPage.DisplayItem.Bookmarks.ViewModel){
        self.currentTab = .Bookmarks
        self.bookmarkItems = viewModel.bookmarkItems
        self.basicViewModel = viewModel.title
        self.createBtn.isEnabled = true
        self.tableView.dragInteractionEnabled = true
        self.tableView.reloadData()
    }
    
    func displayReminders(viewModel: MainPage.DisplayItem.Reminders.ViewModel){
        self.currentTab = .Reminders
        self.reminderItems = viewModel.reminderItems
        self.basicViewModel = viewModel.title
        self.createBtn.isEnabled = true
        self.tableView.dragInteractionEnabled = true
        self.tableView.reloadData()
    }
    
    func displayUpcoming(viewModel: MainPage.DisplayItem.UpcomingReminders.ViewModel){
        DispatchQueue.main.async{
            self.currentTab = .Upcoming
            self.upcomingReminderItem = viewModel.upcomingReminder
            self.basicViewModel = viewModel.title
            self.createBtn.isEnabled = false
            self.tableView.dragInteractionEnabled = false
            self.tableView.reloadData()
        }
    }
    
    func updateETAs(etaList: MainPage.DisplayItem.Bookmarks.ETAViewModel){
        self.bookmarkETAViewModel = etaList
        self.tableView.reloadData()
    }
}
