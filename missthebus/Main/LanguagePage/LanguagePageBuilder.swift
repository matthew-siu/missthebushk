//
//  LanguagePageBuilder.swift
//  missthebus
//
//  Created by Matthew Siu on 20/8/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class LanguagePageBuilder
{
    
    // - Storyboard
    private static let _storyboard = UIStoryboard(name: "LanguagePageViewController", bundle: nil)
    
    // - Creator
    class func createScene(request: BuildRequest) -> LanguagePageViewController
    {
        let viewController = _storyboard.instantiateViewController(ofType: LanguagePageViewController.self)
        let interactor = LanguagePageInteractor(request: request)
        let presenter = LanguagePagePresenter()
        let router = LanguagePageRouter()
        
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
extension LanguagePageBuilder {
    struct BuildRequest {

    }
}
