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
class AboutUsPageViewController: BaseTableViewController, AboutUsPageDisplayLogic
{
    // VIP
    var interactor: AboutUsPageBusinessLogic?
    var router: (NSObjectProtocol & AboutUsPageRoutingLogic & AboutUsPageDataPassing)?
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    let email = "krescendo.studio@gmail.com"
    
    @IBAction func onClickCopyEmail(_ sender: Any) {
        UIPasteboard.general.string = self.email
        self.showToast(message: "setting_copied_to_board".localized())
    }
    
    @IBAction func exploreMore(_ sender: Any) {
        guard let url = URL(string: Configs.Network.developerAppStoreLink) else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - View Lifecycle
extension AboutUsPageViewController {
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "setting_about_us".localized()
        self.emailLabel.text = email
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
            self.versionLabel.text = "v\(appVersion)"
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: .init(x: 0, y: 0, width: self.width, height: 55))
        headerView.backgroundColor = UIColor.SoftUI.major
        let headerLabel = UILabel(frame: .init(x: 20, y: 0, width: self.width - 24, height: 40))
        switch section{
            case 0: headerLabel.text = "General"
            case 1: headerLabel.text = "Disclaimer"
        default:
            headerLabel.text = ""
        }
        headerLabel.useTextStyle(.label_sub)
        headerLabel.sizeToFit()
        headerLabel.textColor = UIColor.MTB.darkGray
        headerLabel.center.y = headerView.center.y
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.SoftUI.major
    }
}

// MARK:- View Display logic entry point
extension AboutUsPageViewController {

}
