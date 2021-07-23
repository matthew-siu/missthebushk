//
//  StopListPageRouter.swift
//  missthebus
//
//  Created by Matthew Siu on 20/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - The main interface to be called by others
protocol StopListPageRoutingLogic
{
    
}

// MARK: - The possible elements that can be
protocol StopListPageDataPassing
{
    var dataStore: StopListPageDataStore? { get }
}

// MARK: - Main router body
class StopListPageRouter: NSObject, StopListPageRoutingLogic, StopListPageDataPassing
{
    weak var viewController: StopListPageViewController?
    var dataStore: StopListPageDataStore?
}

// MARK: - Routing and datapassing for one nav action
extension StopListPageRouter {

}
