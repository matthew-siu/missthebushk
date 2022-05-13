//
//  BaseTableViewController.swift
//  missthebus
//
//  Created by Matthew Siu on 20/8/2021.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style: .plain, target:nil, action:nil)
        self.view.backgroundColor = UIColor.SoftUI.major
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Navigation Controller transparent bar reset
        self.navigationController?.view.layoutIfNeeded()
    }

}


extension BaseTableViewController{
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
    
    func showToast(message : String) {
        var height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        height -= (window?.safeAreaInsets.bottom)!
        
        let toastLabel = UILabel(frame: CGRect(x: width - 80, y: height - 100, width: 250, height: 30))
        toastLabel.backgroundColor = .clear
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = toastLabel.font.withSize(15.0)
        toastLabel.numberOfLines = 0
        toastLabel.text = message
        
        
        // autosizing after entering text
        toastLabel.clipsToBounds  =  true
        toastLabel.sizeToFit()
        toastLabel.center.x = self.view.center.x
        
        // resize frame
        let toast = UIView(frame: CGRect(origin: toastLabel.frame.origin, size: CGSize(width: toastLabel.frame.width + 40, height: toastLabel.frame.height + 20)))
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toast.layer.cornerRadius = 15
        toast.center = toastLabel.center
        toastLabel.center = CGPoint(x: toast.frame.width/2, y: toast.frame.height/2)
        
        toast.addSubview(toastLabel)
        self.view.addSubview(toast)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            toast.alpha = 1.0
        }, completion: {(isCompleted) in
            UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut, animations: {
                toast.alpha = 0.0
            }, completion: {(isCompleted) in
                toast.removeFromSuperview()
            })
        })
        
    }
}
