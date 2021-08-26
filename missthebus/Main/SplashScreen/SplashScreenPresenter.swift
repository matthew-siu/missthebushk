//
//  SplashScreenPresenter.swift
//  missthebus
//
//  Created by Matthew Siu on 30/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Presentation logic goes here
protocol SplashScreenPresentationLogic
{
    func displayLoadingMsg(msg: String)
    func updateProgressBar(to percentage: Float)
}

// MARK: - Presenter main body
class SplashScreenPresenter: SplashScreenPresentationLogic
{
    weak var viewController: SplashScreenDisplayLogic?
    
}

// MARK: - Presentation receiver
extension SplashScreenPresenter {
    
    func updateProgressBar(to percentage: Float){
        self.viewController?.updateProgressBar(to: percentage)
    }
    
    func displayLoadingMsg(msg: String){
        self.viewController?.displayLoadingMsg(msg: msg)
    }
}
