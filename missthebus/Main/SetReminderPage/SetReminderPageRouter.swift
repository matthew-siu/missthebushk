//
//  SetReminderPageRouter.swift
//  missthebus
//
//  Created by Matthew Siu on 26/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - The main interface to be called by others
protocol SetReminderPageRoutingLogic
{
    
}

// MARK: - The possible elements that can be
protocol SetReminderPageDataPassing
{
    var dataStore: SetReminderPageDataStore? { get }
}

// MARK: - Main router body
class SetReminderPageRouter: NSObject, SetReminderPageRoutingLogic, SetReminderPageDataPassing
{
    weak var viewController: SetReminderPageViewController?
    var dataStore: SetReminderPageDataStore?
}

// MARK: - Routing and datapassing for one nav action
extension SetReminderPageRouter {

}
