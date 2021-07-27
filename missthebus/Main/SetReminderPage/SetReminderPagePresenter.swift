//
//  SetReminderPagePresenter.swift
//  missthebus
//
//  Created by Matthew Siu on 26/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Presentation logic goes here
protocol SetReminderPagePresentationLogic
{
    func displayInitialState(route: KmbRoute, stop: KmbStop)
}

// MARK: - Presenter main body
class SetReminderPagePresenter: SetReminderPagePresentationLogic
{
    weak var viewController: SetReminderPageDisplayLogic?
    
}

// MARK: - Presentation receiver
extension SetReminderPagePresenter {
    func displayInitialState(route: KmbRoute, stop: KmbStop){
        print("self.viewController?.displayInitialState(route: route, stop: stop)")
        self.viewController?.displayCreateState(route: route, stop: stop)
    }
}
