//
//  AboutUsPageRouter.swift
//  missthebus
//
//  Created by Matthew Siu on 20/8/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - The main interface to be called by others
protocol AboutUsPageRoutingLogic
{
    
}

// MARK: - The possible elements that can be
protocol AboutUsPageDataPassing
{
    var dataStore: AboutUsPageDataStore? { get }
}

// MARK: - Main router body
class AboutUsPageRouter: NSObject, AboutUsPageRoutingLogic, AboutUsPageDataPassing
{
    weak var viewController: AboutUsPageViewController?
    var dataStore: AboutUsPageDataStore?
}

// MARK: - Routing and datapassing for one nav action
extension AboutUsPageRouter {

}
