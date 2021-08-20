//
//  LanguagePageViewController.swift
//  missthebus
//
//  Created by Matthew Siu on 20/8/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Display logic, receive view model from presenter and present
protocol LanguagePageDisplayLogic: class
{

}

// MARK: - View Controller body
class LanguagePageViewController: BaseTableViewController, LanguagePageDisplayLogic
{
    // VIP
    var interactor: LanguagePageBusinessLogic?
    var router: (NSObjectProtocol & LanguagePageRoutingLogic & LanguagePageDataPassing)?
    
    
}

// MARK: - View Lifecycle
extension LanguagePageViewController {
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "setting_languges_title".localized()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0){
            Storage.save(Configs.Storage.KEY_LANGUAGE, AppLanguage.english.rawValue)
        }else if (indexPath.row == 1){
            Storage.save(Configs.Storage.KEY_LANGUAGE, AppLanguage.traditionalChinese.rawValue)
        }else if (indexPath.row == 2){
            Storage.save(Configs.Storage.KEY_LANGUAGE, AppLanguage.simplifiedChinese.rawValue)
            
        }
        self.router?.restartApp()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK:- View Display logic entry point
extension LanguagePageViewController {

}
