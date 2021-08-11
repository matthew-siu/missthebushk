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
    func displayInitialState(route: KmbRoute, stopList: [KmbStop], bookmarks: [StopBookmark], selectedStopId: String?, requestType: StopListPage.RequestType?)
    func displayETAOnOneStop(etaList: StopListPage.DisplayItem.ETAViewModel)
}

// MARK: - View Controller body
class StopListPageViewController: BaseViewController, StopListPageDisplayLogic
{
    
    // VIP
    var interactor: StopListPageBusinessLogic?
    var router: (NSObjectProtocol & StopListPageRoutingLogic & StopListPageDataPassing)?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var stopListView: UIView!
    @IBOutlet weak var stopListTabView: UIView!
    @IBOutlet weak var expandViewBtn: UIButton!
    @IBOutlet weak var tableViewTopMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var adsBannerView: GADBannerView!
    @IBOutlet weak var adsBannerHeightConstraint: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    
    var type: StopListPage.RequestType = .NormalNavigation
    
    var route: KmbRoute?
    var stopList = [KmbStop]()
    var bookmarks = [StopBookmark]()
    var googleMapMarker = [GMSMarker]()
    var selectedPosition: CLLocationCoordinate2D?
    var selectedETAIndex = -1
    var selectedStopETAView: StopListPage.DisplayItem.ETAViewModel?
    var getRouteStopResponse: SetReminderPage.GetRouteStopResponse?
    
    
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
        self.tableView.separatorStyle = .none
        
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            print("location service abled")
//            self.locationManager.requestLocation()
        } else {
            print("location service disabled")
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        self.initUI()
        
        self.initBanner(self.adsBannerView, heightConstaint: self.adsBannerHeightConstraint)
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
        let bookmarked = self.bookmarks.contains(where: {$0.stopId == item.stopId})
        cell.delegate = self
        
        // update general viewModel
        if (self.type == .NormalNavigation){
            cell.selectionStyle = .none
            let isSelected = (indexPath.row == selectedETAIndex)
            
            cell.setInfo(index: indexPath.row + 1, stop: item, isSelected: isSelected, count: self.stopList.count, isBookmarked: bookmarked)
        }else{
            cell.selectionStyle = .default
            let isSelected = self.getRouteStopResponse?.stopSeqList.contains(indexPath.row) ?? false
            
            cell.setInfo(index: indexPath.row + 1, stop: item, isSelected: isSelected, count: self.stopList.count)
            
        }
        
        // update ETA
        if let etaViewModel = self.selectedStopETAView{
            if etaViewModel.etaViews.contains(where: {$0.seq == indexPath.row + 1}) {
                cell.setETA(etaList: self.selectedStopETAView)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == self.selectedETAIndex) ? 140 : 80
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (self.getRouteStopResponse?.stopSeqList.count ?? 0 >= 2){
            self.showToast(message: "stop_service_err_at_most_pick".localized())
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (self.type == .GetRouteStopService){
            self.getRouteStopResponse?.stopSeqList.append(indexPath.row)
//            self.tableView.reloadData()
            return
        }else{
            self.selectedETAIndex = (self.selectedETAIndex != indexPath.row) ? indexPath.row : -1
            if (self.selectedETAIndex == -1) {
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (self.type == .GetRouteStopService){
            self.getRouteStopResponse?.stopSeqList.removeAll(where: {$0 == indexPath.row})
            return
        }
    }
}

extension StopListPageViewController: StopItemCellDelegate{
    func setBookmark(stop: KmbStop, isMarked: Bool) {
        print("bookmark: \(isMarked) on \(stop.name)")
        
        self.interactor?.bookmark(stop: stop, isMarked: isMarked)
        let msg = (isMarked) ? "stop_bookmark_succeed".localized() : "stop_unbookmark_succeed".localized()
        self.showToast(message: msg)
    }
}

// MARK:- Google Map API
extension StopListPageViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
          return
        }
        print("GoogleMap: didChangeAuthorization")
        
//        manager.requestLocation()
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
        self.expandViewBtn.addTarget(self, action: #selector(expandView), for: .touchUpOutside)
        
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

    func displayInitialState(route: KmbRoute, stopList: [KmbStop], bookmarks: [StopBookmark], selectedStopId: String?, requestType: StopListPage.RequestType? = .NormalNavigation){
        self.type = requestType ?? .NormalNavigation
        if (self.type == .GetRouteStopService){
            self.setGetRouteStopServiceState()
            self.getRouteStopResponse = self.interactor?.getRouteStopResponse()
        }
        
        self.title = "\(route.route) \("route_to".localized()) \(route.destStop)"
        self.route = route
        self.stopList = stopList
        self.bookmarks = bookmarks
        if let selectedStopId = selectedStopId{
            self.selectedETAIndex = self.stopList.firstIndex(where: {$0.stopId == selectedStopId}) ?? -1
        }
        self.tableView.reloadData {
            if let _ = selectedStopId{
                self.tableView.scrollToRow(at: IndexPath(row: self.selectedETAIndex, section: 0), at: .top, animated: true)
            }
        }
        self.displayGoogleMapView()
    }
    
    func displayETAOnOneStop(etaList: StopListPage.DisplayItem.ETAViewModel){
        self.selectedStopETAView = etaList
        self.tableView.reloadData()
    }
    
    func setGetRouteStopServiceState(){
        print("setGetRouteStopServiceState")
        self.tableView.allowsSelection = true
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsSelectionDuringEditing = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        let saveBtn = UIBarButtonItem(title: "general_save".localized(), style: .plain, target: self, action: #selector(self.onSave))
        saveBtn.tintColor = .systemBlue
        self.navigationItem.rightBarButtonItem = saveBtn
        
    }
    
    @objc func onSave(){
        if let resp = self.getRouteStopResponse{
            if (resp.stopSeqList.count == 0){
                self.showAlert("general_save".localized(), "stop_service_err_at_least_pick".localized()) { (_) in}
            }else{
                self.router?.responseGetRouteStopService(resp: resp)
            }
        }
        
    }
}
