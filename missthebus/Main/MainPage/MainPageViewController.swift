//
//  MainPageViewController.swift
//  missthebus
//
//  Created by Matthew Siu on 6/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

// MARK: - Display logic, receive view model from presenter and present
protocol MainPageDisplayLogic: class
{
    func displayReminders(reminders: [StopReminder])
}

// MARK: - View Controller body
class MainPageViewController: BaseViewController, MainPageDisplayLogic
{
    // VIP
    var interactor: MainPageBusinessLogic?
    var router: (NSObjectProtocol & MainPageRoutingLogic & MainPageDataPassing)?
    
    @IBOutlet weak var mainMsg1: UILabel!
    @IBOutlet weak var mainMsg2: UILabel!
    @IBOutlet weak var searchSoftUIView: SoftUIView! // button behaviour
    @IBOutlet weak var searchImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var stopList = [KmbStop]()
    var reminders = [StopReminder]()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.interactor?.loadAllStopRemindersOfRoute()
        
    }
    
    private func initUI(){
        self.mainMsg1.useTextStyle(.label)
        self.mainMsg2.useTextStyle(.label_sub)
        
        setSearchBtn()
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

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.itemCell.reuseId, for: indexPath) as! StopReminderTableViewCell

        let reminder = reminders[indexPath.row]
        if let route = KmbManager.getRoute(route: reminder.route, bound: reminder.bound, serviceType: reminder.serviceType),
           let stop = KmbManager.getStop(stopId: reminder.stopId){
            cell.setInfo(routeNum: route.route, destStopName: route.destStop, currentStopName: stop.name, busCompany: route.company)
            cell.backgroundColor = .clear
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        self.router?.routeToStopListPage(reminder: self.reminders[indexPath.row])
    }
    
}

// MARK:- View Display logic entry point
extension MainPageViewController {
    func displayReminders(reminders: [StopReminder]){
        self.reminders = reminders
        print("# reminder = \(self.reminders.count)")
        self.tableView.reloadData()
    }
}
