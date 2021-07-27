//
//  SetReminderPageInteractor.swift
//  missthebus
//
//  Created by Matthew Siu on 26/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Requests from view
protocol SetReminderPageBusinessLogic
{
    func displayInitialState()
}

// MARK: - Datas retain in interactor defines here
protocol SetReminderPageDataStore
{
    
}

// MARK: - Interactor Body
class SetReminderPageInteractor: SetReminderPageBusinessLogic, SetReminderPageDataStore
{
    // VIP Properties
    var presenter: SetReminderPagePresentationLogic?
    var worker: SetReminderPageWorker?
    
    // State
    var route: KmbRoute
    var stop: KmbStop
    
    // Init
    init(request: SetReminderPageBuilder.BuildRequest) {
        self.route = request.route
        self.stop = request.stop
    }
    
    
}

// MARK: - Business
extension SetReminderPageInteractor {
    func displayInitialState(){
        self.presenter?.displayInitialState(route: self.route, stop: self.stop)
    }
}
