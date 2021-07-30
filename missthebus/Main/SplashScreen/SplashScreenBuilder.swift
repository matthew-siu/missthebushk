//
//  SplashScreenBuilder.swift
//  missthebus
//
//  Created by Matthew Siu on 30/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class SplashScreenBuilder
{
    
    // - Storyboard
    private static let _storyboard = UIStoryboard(name: "SplashScreenViewController", bundle: nil)
    
    // - Creator
    class func createScene(request: BuildRequest) -> SplashScreenViewController
    {
        let viewController = _storyboard.instantiateViewController(ofType: SplashScreenViewController.self)
        let interactor = SplashScreenInteractor(request: request)
        let presenter = SplashScreenPresenter()
        let router = SplashScreenRouter()
        
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
extension SplashScreenBuilder {
    struct BuildRequest {

    }
}
