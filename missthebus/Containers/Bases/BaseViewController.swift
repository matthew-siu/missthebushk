//
//  ViewController.swift
//  missthebus
//
//  Created by Matthew Siu on 6/7/2021.
//

import UIKit
import GoogleMobileAds

class BaseViewController: UIViewController {

    // Navigation bar title as a custom label
    override var title: String? {
        didSet {
            var textColor = Color.white
            if let navVC = self.navigationController as? NavigationController {
                textColor = navVC.navigationBarStyle.titleTextColor
            }
            let titleLabel = UILabel().useTextColor(textColor)
            titleLabel.text = title
            titleLabel.sizeToFit()
            self.navigationItem.titleView = titleLabel
        }
    }
    
    var bannerView: GADBannerView!
    var bannerHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // back btn clear label
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.view.backgroundColor = UIColor.SoftUI.major
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Navigation Controller transparent bar reset
        self.navigationController?.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

extension BaseViewController{
    func initSoftUI(_ obj: SoftUIView, inverted: Bool? = false, type: SoftUIViewType? = .pushButton){
        obj.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        obj.cornerRadius = 10
        obj.shadowOffset = .init(width: 2, height: 2)
        obj.shadowOpacity = UIColor.SoftUI.opacity
        
        if let inverted = inverted, let type = type {
            obj.isSelected = inverted
            obj.type = type
        }
    }
    
    func showAlert(_ title: String, _ msg: String, completion: @escaping(Bool?) -> ()){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        // Cancel action
        let okAction = UIAlertAction(title: "general_ok".localized(), style: .default) { (_) in
            completion(nil)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showYesNoAlert(_ title: String, _ msg: String, completion: @escaping(Bool) -> ()){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "general_confirm".localized(), style: .default, handler: { (action: UIAlertAction!) in
            completion(true)
          }))

        alertController.addAction(UIAlertAction(title: "general_cancel".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
            completion(false)
          }))

        self.present(alertController, animated: true, completion: nil)
    }
}

// Admob
extension BaseViewController: GADBannerViewDelegate{
    func initBanner(_ bannerView: GADBannerView? = GADBannerView(adSize: kGADAdSizeBanner), heightConstaint: NSLayoutConstraint){
        self.bannerHeightConstraint = heightConstaint
        self.bannerView = bannerView
        print("bannerUnitId: \(Configs.Admob.bannerUnitId)")
        self.bannerHeightConstraint.priority = .defaultLow
//        self.bannerHeightConstraint.constant = 0
//        self.bannerView.adSize = GADAdSizeFromCGSize(CGSize(width: self.bannerView.frame.width, height: 0))
        self.bannerView.adUnitID = Configs.Admob.bannerUnitId
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        self.bannerView.load(GADRequest())
    }
    
    func addBannerToView(_ bannerView: GADBannerView){
        self.bannerView.translatesAutoresizingMaskIntoConstraints = false
//        self.bannerHeightConstraint.constant = 50
//        self.bannerView.adSize = GADAdSizeFromCGSize(CGSize(width: self.bannerView.frame.width, height: 50))
    }
    
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("banner bannerViewDidReceiveAd")
        self.addBannerToView(bannerView)
        
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("banner bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("banner bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("banner bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("banner bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("banner bannerViewDidDismissScreen")
    }
}
