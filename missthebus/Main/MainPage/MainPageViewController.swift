//
//  MainPageViewController.swift
//  missthebus
//
//  Created by Matthew Siu on 6/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

// MARK: - Display logic, receive view model from presenter and present
protocol MainPageDisplayLogic: class
{

}

// MARK: - View Controller body
class MainPageViewController: BaseViewController, MainPageDisplayLogic
{
    // VIP
    var interactor: MainPageBusinessLogic?
    var router: (NSObjectProtocol & MainPageRoutingLogic & MainPageDataPassing)?
    
    @IBOutlet weak var mainMsg1: UILabel!
    @IBOutlet weak var mainMsg2: UILabel!
    var id: Int = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(){
        let viewController = self
        let interactor = MainPageInteractor()
        let presenter = MainPagePresenter()
        let router = MainPageRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
}

// MARK: - View Lifecycle
extension MainPageViewController {
    override func viewDidLoad()
    {
        print("hello world \(id)")
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initUI()
        self.requestAllKmbStaticInfo()
    }
    
    private func initUI(){
        if let font = UIFont.init(name: "AvenirNext-Regular", size: 24){
            self.mainMsg1.useFont(font: font)
        }
        if let font = UIFont.init(name: "AvenirNext-Regular", size: 14){
            self.mainMsg2.useFont(font: font)
        }
        
        setSearchBtn()
    }
    
    
    private func setSearchBtn(){
        let softUIView = SoftUIButton(frame: .init(x: 100, y: 100, width: 200, height: 200))
        softUIView.setThemeColor(UIColor.SoftUI.major, UIColor.SoftUI.dark, UIColor.SoftUI.light)
        softUIView.cornerRadius = 50
        softUIView.shadowOffset = .init(width: 5, height: 5)
        softUIView.shadowOpacity = 0.5
        softUIView.label.text = "Search Bus!"
        softUIView.center.x = self.view.center.x
        softUIView.center.y = self.view.frame.maxY - softUIView.frame.height

        softUIView.addTarget(self, action: #selector(goToSearchPage), for: .touchUpInside)

        self.view.addSubview(softUIView)
    }
    
    @objc
    private func goToSearchPage(_: AnyObject){
        self.router?.routeToSearchPage()
    }
}

// MARK:- View Display logic entry point
extension MainPageViewController {
    func requestAllKmbStaticInfo(){
        self.interactor?.requestAllKmbStaticInfo()
    }
}
