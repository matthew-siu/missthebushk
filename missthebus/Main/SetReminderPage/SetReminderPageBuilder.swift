//
//  SetReminderPageBuilder.swift
//  missthebus
//
//  Created by Matthew Siu on 26/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class SetReminderPageBuilder
{
    
    // - Storyboard
    private static let _storyboard = UIStoryboard(name: "SetReminderPageViewController", bundle: nil)
    
    // - Creator
    class func createScene(request: BuildRequest) -> SetReminderPageViewController
    {
        let viewController = _storyboard.instantiateViewController(ofType: SetReminderPageViewController.self)
        let interactor = SetReminderPageInteractor(request: request)
        let presenter = SetReminderPagePresenter()
        let router = SetReminderPageRouter()
        
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
extension SetReminderPageBuilder {
    struct BuildRequest {
        let route: KmbRoute?
        let stop: KmbStop?
        let mode: SetReminderPage.Mode
        let reminder: StopReminder?
    }
}
