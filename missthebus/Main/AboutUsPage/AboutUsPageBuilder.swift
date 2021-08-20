//
//  AboutUsPageBuilder.swift
//  missthebus
//
//  Created by Matthew Siu on 20/8/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class AboutUsPageBuilder
{
    
    // - Storyboard
    private static let _storyboard = UIStoryboard(name: "AboutUsPageViewController", bundle: nil)
    
    // - Creator
    class func createScene(request: BuildRequest) -> AboutUsPageViewController
    {
        let viewController = _storyboard.instantiateViewController(ofType: AboutUsPageViewController.self)
        let interactor = AboutUsPageInteractor(request: request)
        let presenter = AboutUsPagePresenter()
        let router = AboutUsPageRouter()
        
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
extension AboutUsPageBuilder {
    struct BuildRequest {

    }
}
