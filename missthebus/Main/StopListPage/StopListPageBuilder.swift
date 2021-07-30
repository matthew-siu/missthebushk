//
//  StopListPageBuilder.swift
//  missthebus
//
//  Created by Matthew Siu on 20/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class StopListPageBuilder
{
    
    // - Storyboard
    private static let _storyboard = UIStoryboard(name: "StopListPageViewController", bundle: nil)
    
    // - Creator
    class func createScene(request: BuildRequest) -> StopListPageViewController
    {
        let viewController = _storyboard.instantiateViewController(ofType: StopListPageViewController.self)
        let interactor = StopListPageInteractor(request: request)
        let presenter = StopListPagePresenter()
        let router = StopListPageRouter()
        
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
extension StopListPageBuilder {
    struct BuildRequest {
        let route: KmbRoute
        let stop: KmbStop?
    }
}
