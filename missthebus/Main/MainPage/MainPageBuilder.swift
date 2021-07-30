//
//  MainPageBuilder.swift
//  missthebus
//
//  Created by Matthew Siu on 30/7/2021.
//

import UIKit

class MainPageBuilder
{
    
    // - Storyboard
    private static let _storyboard = UIStoryboard(name: "MainPageViewController", bundle: nil)
    
    // - Creator
    class func createScene(request: BuildRequest) -> MainPageViewController
    {
        
        let viewController = _storyboard.instantiateViewController(ofType: MainPageViewController.self)
        let interactor = MainPageInteractor(request: request)
        let presenter = MainPagePresenter()
        let router = MainPageRouter()
        
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
extension MainPageBuilder {
    struct BuildRequest {

    }
}
