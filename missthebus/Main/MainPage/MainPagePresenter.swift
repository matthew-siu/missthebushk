//
//  MainPagePresenter.swift
//  missthebus
//
//  Created by Matthew Siu on 6/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Presentation logic goes here
protocol MainPagePresentationLogic
{
    func displayReminders(reminders: [StopReminder])
}

// MARK: - Presenter main body
class MainPagePresenter: MainPagePresentationLogic
{
    weak var viewController: MainPageDisplayLogic?
    
}

// MARK: - Presentation receiver
extension MainPagePresenter {
    
    func displayReminders(reminders: [StopReminder]){
        self.viewController?.displayReminders(reminders: reminders)
    }
}
