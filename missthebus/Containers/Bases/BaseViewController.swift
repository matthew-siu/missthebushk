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

extension BaseViewController{
    func initSoftUI(_ obj: SoftUIView, inverted: Bool? = false, type: SoftUIViewType? = .pushButton){
        obj.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        obj.cornerRadius = 10
        obj.shadowOffset = .init(width: 2, height: 2)
        obj.shadowOpacity = 1
        
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

