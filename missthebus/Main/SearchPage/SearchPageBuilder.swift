//
//  SearchPageBuilder.swift
//  missthebus
//
//  Created by Matthew Siu on 7/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class SearchPageBuilder
{
    
    // - Storyboard
    private static let _storyboard = UIStoryboard(name: "SearchPageViewController", bundle: nil)
    
    // - Creator
    class func createScene(request: BuildRequest) -> SearchPageViewController
    {
        
        let viewController = _storyboard.instantiateViewController(ofType: SearchPageViewController.self)
        let interactor = SearchPageInteractor(request: request)
        let presenter = SearchPagePresenter()
        let router = SearchPageRouter()
        
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
extension SearchPageBuilder {
    struct BuildRequest {

    }
}
