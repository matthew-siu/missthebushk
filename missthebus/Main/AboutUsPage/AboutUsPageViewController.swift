//
//  AboutUsPageViewController.swift
//  missthebus
//
//  Created by Matthew Siu on 20/8/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Display logic, receive view model from presenter and present
protocol AboutUsPageDisplayLogic: class
{

}

// MARK: - View Controller body
class AboutUsPageViewController: BaseViewController, AboutUsPageDisplayLogic
{
    // VIP
    var interactor: AboutUsPageBusinessLogic?
    var router: (NSObjectProtocol & AboutUsPageRoutingLogic & AboutUsPageDataPassing)?
    
    
}

// MARK: - View Lifecycle
extension AboutUsPageViewController {
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "setting_about_us".localized()
    }
}

// MARK:- View Display logic entry point
extension AboutUsPageViewController {

}
