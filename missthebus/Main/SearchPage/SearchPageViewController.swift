//
//  SearchPageViewController.swift
//  missthebus
//
//  Created by Matthew Siu on 7/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Display logic, receive view model from presenter and present
protocol SearchPageDisplayLogic: class
{
    func presentTableView(routeData: [KmbRoute])

}

// MARK: - View Controller body
class SearchPageViewController: BaseViewController, SearchPageDisplayLogic
{
    
    // VIP
    var interactor: SearchPageBusinessLogic?
    var router: (NSObjectProtocol & SearchPageRoutingLogic & SearchPageDataPassing)?
    
    @IBOutlet weak var searchTextfield: SoftUITextfield!
    @IBOutlet weak var tableView: UITableView!
    let gradientLayer = CAGradientLayer() // TableView Faded Edges
    
    private var routeList = [KmbRoute]()
    private var filteredRouteList = [KmbRoute]()
    
    enum TableViewCell: String, TableViewCellConfiguration {
        case itemCell = "RouteItemTableViewCell"
    }
}

// MARK: - View Lifecycle
extension SearchPageViewController {
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "search_title".localized()
        self.searchTextfield.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = true
        self.tableView.register(TableViewCell.itemCell.nib, forCellReuseIdentifier: TableViewCell.itemCell.reuseId)
        self.tableView.estimatedRowHeight = 200
        
        // hide keyboard when tap anywhere
        self.hideKeyboardWhenTappedAround()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.requestKmbRouteList()
        
        // auto open keyboard
        self.searchTextfield.becomeFirstResponder()
    }
    
    private func initUI(){
        self.addFadedEdgeToTableView()
        self.setSearchTextfield()
        self.setSwitchKeyboard()
    }
    
    func addFadedEdgeToTableView() {
        self.gradientLayer.frame = CGRect(x: 0, y: self.tableView.frame.origin.y, width: tableView.bounds.width, height: 50.0)
        self.gradientLayer.colors = [UIColor.SoftUI.major.cgColor, UIColor.SoftUI.major.withAlphaComponent(0).cgColor]
        self.view.layer.addSublayer(self.gradientLayer)
    }
    
    private func setSwitchKeyboard(){
        
        let doneToolbar: UIToolbar = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "switch_keyboard".localized(), style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.searchTextfield.inputAccessoryView = doneToolbar

        self.searchTextfield.keyboardType = .numberPad
    }
    
    private func setSearchTextfield(){
        self.searchTextfield.enablesReturnKeyAutomatically = true
        self.searchTextfield.placeholder = "search_label".localized()
        self.searchTextfield.textColor = .darkText
        self.searchTextfield.useTextStyle(.label)
        self.searchTextfield.setLeftPaddingPoints(15)
        self.searchTextfield.setRightPaddingPoints(15)
        
        self.searchTextfield.setThemeColor(majorColor: UIColor.SoftUI.major, darkColor: UIColor.SoftUI.dark, lightColor: UIColor.SoftUI.light)
        
        self.searchTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    override func viewDidLayoutSubviews() {
        initUI()
    }
}

extension SearchPageViewController: UITextFieldDelegate{
    
    // hide numpad
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchTextfield.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // on text change, execute filtering
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("changing.")
        if (self.searchTextfield.text?.count ?? "".count > 0){
            
            self.filteredRouteList = self.routeList.filter{$0.route.contains(self.searchTextfield.text?.uppercased() ?? "")}
        }else{
            self.filteredRouteList = self.routeList
        }
        
        self.tableView.reloadData()
        
    }
    
}

extension SearchPageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredRouteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.filteredRouteList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.itemCell.reuseId, for: indexPath) as! RouteItemTableViewCell
        cell.setInfo(vc:self, route: item)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selecting \(self.filteredRouteList[indexPath.row].route)")
        self.router?.routeToStopListPage(route: self.filteredRouteList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

// MARK:- Action
extension SearchPageViewController {
    
    @objc
    func doneButtonAction(){
            
        if (self.searchTextfield.keyboardType == .default){
            self.searchTextfield.keyboardType = .numberPad
        }else if (self.searchTextfield.keyboardType == .numberPad){
            self.searchTextfield.keyboardType = .default
        }
        self.searchTextfield.reloadInputViews()
    }
}

// MARK:- View Display logic entry point
extension SearchPageViewController {
    
    func requestKmbRouteList(){
        self.interactor?.requestKmbRouteList()
    }
    
    
    func presentTableView(routeData: [KmbRoute]) {
        self.routeList = routeData
        self.filteredRouteList = self.routeList
        self.tableView.reloadData()
    }
}
