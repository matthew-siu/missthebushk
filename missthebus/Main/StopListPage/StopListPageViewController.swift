//
//  StopListPageViewController.swift
//  missthebus
//
//  Created by Matthew Siu on 20/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMobileAds

// MARK: - Display logic, receive view model from presenter and present
protocol StopListPageDisplayLogic: class
{
    func displayInitialState(route: KmbRoute, stopList: [KmbStop], reminders: [StopReminder], selectedStopId: String?)
    func displayETAOnOneStop(etaList: StopListPage.DisplayItem.ViewModel)
}

// MARK: - View Controller body
class StopListPageViewController: BaseViewController, StopListPageDisplayLogic
{
    
    // VIP
    var interactor: StopListPageBusinessLogic?
    var router: (NSObjectProtocol & StopListPageRoutingLogic & StopListPageDataPassing)?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var adsBannerView: GADBannerView!
    @IBOutlet weak var stopListView: UIView!
    @IBOutlet weak var stopListTabView: UIView!
    @IBOutlet weak var expandViewBtn: UIButton!
    @IBOutlet weak var tableViewTopMarginConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    
    var route: KmbRoute?
    var stopList = [KmbStop]()
    var reminders = [StopReminder]()
    var googleMapMarker = [GMSMarker]()
    var selectedPosition: CLLocationCoordinate2D?
    var selectedIndex = -1
    var selectedStopETAView: StopListPage.DisplayItem.ViewModel?
    
    let minTopMarginConstraint: CGFloat = 110
    var maxTopMarginConstraint: CGFloat {
        return self.width
    }
    
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
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            print("location service abled")
            self.locationManager.requestLocation()
        } else {
            print("location service disabled")
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        self.initUI()
        
        self.initBanner(self.adsBannerView)
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
        let isSelected = (indexPath.row == selectedIndex)
        cell.delegate = self
        cell.setInfo(index: indexPath.row + 1, stop: item, isSelected: isSelected, count: self.stopList.count, isBookmarked: bookmarked)
        
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
        return (indexPath.row == self.selectedIndex) ? 140 : 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndex = (self.selectedIndex != indexPath.row) ? indexPath.row : -1
        if (self.selectedIndex == -1) {
            selectedStopETAView = nil
        }
        // expand view
        self.tableView.reloadData{
            
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
        // request stop ETA API
        let stop = self.stopList[indexPath.row]
        self.interactor?.startETATimer(stopId: stop.stopId, route: self.route!.route, serviceType: self.route!.serviceType)
        
        self.zoomToLocation(stop)
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

// MARK:- Google Map API
extension StopListPageViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
          return
        }
        print("GoogleMap: didChangeAuthorization")
        
        manager.requestLocation()

        //5
//        self.mapView.isMyLocationEnabled = true
//        self.mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
          return
        }
        print("GoogleMap: didUpdateLocations")

        self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("GoogleMap: didFailWithError: \(error.localizedDescription)")
    }
}

// Method:- Google Map API
extension StopListPageViewController: GMSMapViewDelegate{
    
    func displayGoogleMapView(){
        self.googleMapMarker = []
        var bounds = GMSCoordinateBounds()
        
        // 1. set google map marker
        // 2. joint all the stop
        let path = GMSMutablePath()
        for stop  in self.stopList{
            guard let latitude = stop.latitude, let longitude = stop.longitude else {return}
            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let marker = GMSMarker(position: position)
            self.googleMapMarker.append(marker)
            path.add(CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) // join marker
            marker.title = stop.name
            marker.map = self.mapView
            bounds = bounds.includingCoordinate(marker.position)
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor.black
        polyline.strokeWidth = 3.0
        polyline.map = mapView
        
        // resize google map size
        let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 150, left: 100, bottom: self.stopListView.frame.height, right: 100))
        self.mapView.setMinZoom(1, maxZoom: 15) // prevent to over zoom on fit and animate if bounds be too small
        self.mapView.animate(with: update)
        self.mapView.setMinZoom(1, maxZoom: 20) // allow the user zoom in more than level 15 again
    }
    
    func zoomToLocation(_ stop: KmbStop){
        guard let latitude = stop.latitude, let longitude = stop.longitude else {return}
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = self.googleMapMarker.first(where: {$0.position.longitude == position.longitude && $0.position.latitude == position.latitude})
        self.mapView.selectedMarker = marker
        self.zoomToLocation(position: position)
    }
    
    func zoomToLocation(position: CLLocationCoordinate2D){
        self.selectedPosition = position
        let bounds = GMSCoordinateBounds().includingCoordinate(position)
        let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 0, left: 100, bottom: self.stopListView.frame.height, right: 100))
        self.mapView.setMinZoom(1, maxZoom: 15) // unify zoom level
        self.mapView.animate(with: update)
        self.mapView.setMinZoom(1, maxZoom: 15) // allow the user zoom in more than level 15 again
    }
    
    // on click marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if self.googleMapMarker.contains(marker){
            self.zoomToLocation(position: marker.position)
            self.mapView.selectedMarker = marker
        }
        return true
    }
}

// MARK:- View Display logic entry point
extension StopListPageViewController {
    
    override func viewDidLayoutSubviews() {
        self.stopListTabView.roundedTop(20)
    }
    
    func initUI(){
        self.stopListView.backgroundColor = .clear
        self.stopListView.addShadow()
        self.stopListTabView.backgroundColor = UIColor.SoftUI.major
        self.tableView.backgroundColor = UIColor.SoftUI.major
        self.expandViewBtn.imageView?.contentMode = .scaleAspectFit
        let img = UIImage(named: "upDrag")?.withRenderingMode(.alwaysTemplate).tinted(color: #colorLiteral(red: 0.4678121805, green: 0.4678237438, blue: 0.4678175449, alpha: 1)).rotate(radians: .pi)
        self.expandViewBtn.setImage(img, for: .normal)
//        self.expandViewBtn.tintColor =
        self.expandViewBtn.addTarget(self, action: #selector(expandView), for: .touchUpInside)
        
        self.tableViewTopMarginConstraint.constant = self.minTopMarginConstraint
    }
    
    @objc
    func expandView(){
        self.tableViewTopMarginConstraint.constant = (self.tableViewTopMarginConstraint.constant == self.maxTopMarginConstraint) ? self.minTopMarginConstraint : self.maxTopMarginConstraint
        
        let img = self.expandViewBtn.imageView?.image?.tinted(color: #colorLiteral(red: 0.4678121805, green: 0.4678237438, blue: 0.4678175449, alpha: 1)).rotate(radians: .pi)
        self.expandViewBtn.setImage(img, for: .normal)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        if let selectedPosition = self.selectedPosition{
            self.zoomToLocation(position: selectedPosition)
        }
        
    }

    func displayInitialState(route: KmbRoute, stopList: [KmbStop], reminders: [StopReminder], selectedStopId: String?){
        
        self.title = "\(route.route) \("route_to".localized()) \(route.destStop)"
        self.route = route
        self.stopList = stopList
        self.reminders = reminders
        if let selectedStopId = selectedStopId{
            self.selectedIndex = self.stopList.firstIndex(where: {$0.stopId == selectedStopId}) ?? -1
        }
        self.tableView.reloadData {
            if let _ = selectedStopId{
                self.tableView.scrollToRow(at: IndexPath(row: self.selectedIndex, section: 0), at: .top, animated: true)
            }
        }
        self.displayGoogleMapView()
    }
    
    func displayETAOnOneStop(etaList: StopListPage.DisplayItem.ViewModel){
        self.selectedStopETAView = etaList
        self.tableView.reloadData()
    }
    
}
