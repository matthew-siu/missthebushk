//
//  SettingPageViewController.swift
//  missthebus
//
//  Created by Matthew Siu on 20/8/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Display logic, receive view model from presenter and present
protocol SettingPageDisplayLogic: class
{

}

// MARK: - View Controller body
class SettingPageViewController: BaseTableViewController, SettingPageDisplayLogic
{
    // VIP
    var interactor: SettingPageBusinessLogic?
    var router: (NSObjectProtocol & SettingPageRoutingLogic & SettingPageDataPassing)?
    
    @IBOutlet weak var languageTitle: UILabel!
    @IBOutlet weak var clearMemoryTitle: UILabel!
    @IBOutlet weak var aboutUsTitle: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
}

// MARK: - View Lifecycle
extension SettingPageViewController {
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadSetting()
    }
}

extension SettingPageViewController{
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: .init(x: 0, y: 0, width: self.width, height: 40))
        headerView.backgroundColor = UIColor.SoftUI.major
        let headerLabel = UILabel(frame: .init(x: 12, y: 0, width: 100, height: 30))
        switch section{
            case 0: headerLabel.text = "setting_section_general".localized()
            case 1: headerLabel.text = "setting_section_about".localized()
        default:
            headerLabel.text = ""
        }
        headerLabel.sizeToFit()
        headerLabel.useTextStyle(.label_sub)
        headerLabel.textColor = UIColor.MTB.darkGray
        headerLabel.center.y = headerView.center.y + 5
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("on select \(indexPath.section)-\(indexPath.row)")
        if (indexPath.section == 0 && indexPath.row == 0){ // languages
            self.router?.routeToLanguagePage()
        }else if (indexPath.section == 0 && indexPath.row == 1){ // clear memory cache
            self.onClickClearMemory()
        }else if (indexPath.section == 1 && indexPath.row == 0){ // about us
            self.router?.routeToAboutUsPage()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK:- View Display logic entry point
extension SettingPageViewController {
    private func initUI(){
        
        self.title = "general_setting".localized()
        
        self.tableView.isScrollEnabled = false
        
        self.languageTitle.useTextStyle(.label)
        self.clearMemoryTitle.useTextStyle(.label)
        self.aboutUsTitle.useTextStyle(.label)
        self.languageLabel.useTextStyle(.label)
        self.languageTitle.text = "setting_languages".localized()
        self.clearMemoryTitle.text = "setting_clear_memory".localized()
        self.aboutUsTitle.text = "setting_about_us".localized()
        self.languageLabel.text = ""
        
    }
    
    private func loadSetting(){
        if (currentLanguage == .english){
            self.languageLabel.text = "English"
        }else if (currentLanguage == .traditionalChinese){
            self.languageLabel.text = "繁中"
        }else if (currentLanguage == .simplifiedChinese){
            self.languageLabel.text = "简中"
        }
    }
    
    private func onClickClearMemory(){
        self.showYesNoAlert("general_remind".localized(), "setting_clear_memory_confirm".localized()) { (isConfirm) in
            if (isConfirm){
                self.interactor?.clearMemoryCache()
                self.router?.restartApp()
            }
        }
    }
}
