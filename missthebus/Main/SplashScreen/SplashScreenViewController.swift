//
//  SplashScreenViewController.swift
//  missthebus
//
//  Created by Matthew Siu on 30/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
                                                                              
// MARK: - Display logic, receive view model from presenter and present
protocol SplashScreenDisplayLogic: AnyObject
{
    func displayLoadingMsg(msg: String)
    func updateProgressBar(to percentage: Float)
}

// MARK: - View Controller body
class SplashScreenViewController: BaseViewController, SplashScreenDisplayLogic
{
    // VIP
    var interactor: SplashScreenBusinessLogic?
    var router: (NSObjectProtocol & SplashScreenRoutingLogic & SplashScreenDataPassing)?
    
    @IBOutlet weak var softIconView: SoftUIView!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var loadingMsgLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
}

// MARK: - View Lifecycle
extension SplashScreenViewController {
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.requestAllKmbStaticInfo()
    }
}

// MARK:- View Display logic entry point
extension SplashScreenViewController {
    func initUI(){
        self.view.backgroundColor = UIColor.SoftLaunch.major
//        self.view.backgroundColor = UIColor.SoftUI.major
    
        self.softIconView.setThemeColor(UIColor.SoftLaunch.major, UIColor.SoftLaunch.dark, UIColor.SoftLaunch.light)
        self.softIconView.cornerRadius = 20
        self.softIconView.type = .staticView
        self.progressView.progress = 0
        self.progressView.isHidden = true
        self.loadingMsgLabel.isHidden = true
        self.loadingMsgLabel.useTextStyle(.label_sub)
        self.loadingMsgLabel.textColor = .lightGray
        self.loadingMsgLabel.text = "loading_default".localized()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.iconImg.fade(true, 0.5)
        }
    }
    
    func displayLoadingMsg(msg: String){
//        print("[API] displayLoadingMsg: \(msg)")
        self.loadingMsgLabel.text = msg
    }
    
    func updateProgressBar(to percentage: Float){

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.progressView.setProgress(percentage, animated: true)
        }
        self.progressView.setProgress(progressView.progress, animated: true)
    }
    
    func requestAllKmbStaticInfo(){
        
        NSLog("requestAllKmbStaticInfo")
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                
                self.interactor?.requestAllBusStaticInfo()
                    .done{ instant in
                        self.gotoMainPage(!instant)
                    }
                    .catch{ _ in
                        self.gotoMainPage(true)
                    }
            })
        }
    }
    
    func gotoMainPage(_ delay: Bool){
        let sec: Double = delay ? 1 : 0
        DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
            NSLog("gotoMainPage")
            self.router?.routeToMainPage()
        }
    }
}
