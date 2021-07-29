//
//  StopListPageViewController.swift
//  missthebus
//
//  Created by Matthew Siu on 20/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Display logic, receive view model from presenter and present
protocol StopListPageDisplayLogic: class
{
    func displayInitialState(route: KmbRoute, stopList: [KmbStop], reminders: [StopReminder])
    func displayETAOnOneStop(etaList: StopListPage.DisplayItem.ViewModel)
}

// MARK: - View Controller body
class StopListPageViewController: BaseViewController, StopListPageDisplayLogic
{
    
    // VIP
    var interactor: StopListPageBusinessLogic?
    var router: (NSObjectProtocol & StopListPageRoutingLogic & StopListPageDataPassing)?
    
    @IBOutlet weak var tableView: UITableView!
    
    var route: KmbRoute?
    var stopList = [KmbStop]()
    var reminders = [StopReminder]()
    var selectedIndex = -1
    var selectedStopETAView: StopListPage.DisplayItem.ViewModel?
    
    enum TableViewCell: String, TableViewCellConfiguration {
        case itemCell = "StopItemTableViewCell"
    }
    
}

// MARK: - View Lifecycle
extension StopListPageViewController {
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = true
        self.tableView.register(TableViewCell.itemCell.nib, forCellReuseIdentifier: TableViewCell.itemCell.reuseId)
//        self.interactor?.loadAllStopsFromRoute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.interactor?.loadAllStopsFromRoute()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.interactor?.dismissETATimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

extension StopListPageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stopList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.itemCell.reuseId, for: indexPath) as! StopItemTableViewCell
        let item = self.stopList[indexPath.row]
        let bookmarked = self.reminders.contains(where: {$0.stopId == item.stopId})
        cell.delegate = self
        cell.setInfo(index: indexPath.row + 1, stop: item, isSelected: (indexPath.row == selectedIndex), count: self.stopList.count, isBookmarked: bookmarked)
        if let etaViewModel = self.selectedStopETAView{
            if etaViewModel.etaViews.contains(where: {$0.seq == indexPath.row + 1}) {
                cell.setETA(etaList: self.selectedStopETAView)
            }
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == selectedIndex) ? 140 : 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select \(indexPath.row)")
        selectedIndex = (selectedIndex != indexPath.row) ? indexPath.row : -1
        if (selectedIndex == -1) {
            selectedStopETAView = nil
        }
        // expand view
        self.tableView.reloadData()
        
        // request stop ETA API
        let stop = self.stopList[indexPath.row]
        self.interactor?.startETATimer(stopId: stop.stopId, route: self.route!.route, serviceType: self.route!.serviceType)
    }
}

extension StopListPageViewController: StopItemCellDelegate{
    func setReminder(stop: KmbStop) {
        if let route = self.route {
            self.router?.routeToSetReminderPage(mode: .CREATE, route: route, stop: stop)
        }
    }
    
    
    // TODO: view all reminder
    func readReminder() {
        self.showAlert("Not yet finish", "Next view: All reminder of this stop.") { (_) in }
    }
    
    func updateReminder(stop: KmbStop, reminder: StopReminder) {
        if let route = self.route {
            self.router?.routeToSetReminderPage(mode: .UPDATE, route: route, stop: stop)
        }
    }
}

// MARK:- View Display logic entry point
extension StopListPageViewController {

    func displayInitialState(route: KmbRoute, stopList: [KmbStop], reminders: [StopReminder]){
        
        self.title = "\(route.route) \("route_to".localized()) \(route.destStop)"
        self.route = route
        self.stopList = stopList
        self.reminders = reminders
        self.tableView.reloadData()
    }
    
    func displayETAOnOneStop(etaList: StopListPage.DisplayItem.ViewModel){
        self.selectedStopETAView = etaList
        self.tableView.reloadData()
    }
    
}
