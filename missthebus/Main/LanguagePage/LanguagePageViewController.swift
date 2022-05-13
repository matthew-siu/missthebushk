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
            self.confirmChange(lang: AppLanguage.english.rawValue)
        }else if (indexPath.row == 1){
            self.confirmChange(lang: AppLanguage.traditionalChinese.rawValue)
        }else if (indexPath.row == 2){
            self.confirmChange(lang: AppLanguage.simplifiedChinese.rawValue)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK:- View Display logic entry point
extension LanguagePageViewController {
    func confirmChange(lang: String){
        
        self.showYesNoAlert("general_remind".localized(), "setting_languages_confirm".localized() + " \("setting_languages_confirm".localized()) \(lang)?") { (isConfirm) in
                if (isConfirm){
                    Storage.save(suiteName: Configs.SuiteName.AppGroup, Configs.Storage.KEY_LANGUAGE, lang)
                    self.router?.restartApp()
                }
            }
    }
}
