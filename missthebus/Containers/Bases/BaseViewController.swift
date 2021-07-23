//
//  ViewController.swift
//  missthebus
//
//  Created by Matthew Siu on 6/7/2021.
//

import UIKit

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

