//
//  SettingPageBuilder.swift
//  missthebus
//
//  Created by Matthew Siu on 20/8/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class SettingPageBuilder
{
    
    // - Storyboard
    private static let _storyboard = UIStoryboard(name: "SettingPageViewController", bundle: nil)
    
    // - Creator
    class func createScene(request: BuildRequest) -> SettingPageViewController
    {
        let viewController = _storyboard.instantiateViewController(ofType: SettingPageViewController.self)
        let interactor = SettingPageInteractor(request: request)
        let presenter = SettingPagePresenter()
        let router = SettingPageRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        
        return viewController
    }
}

/*
    MARK: - Scene building raw materials
    - All params inject here
*/
extension SettingPageBuilder {
    struct BuildRequest {

    }
}
