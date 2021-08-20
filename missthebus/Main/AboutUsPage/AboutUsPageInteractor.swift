//
//  AboutUsPageInteractor.swift
//  missthebus
//
//  Created by Matthew Siu on 20/8/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Requests from view
protocol AboutUsPageBusinessLogic
{
    
}

// MARK: - Datas retain in interactor defines here
protocol AboutUsPageDataStore
{
    
}

// MARK: - Interactor Body
class AboutUsPageInteractor: AboutUsPageBusinessLogic, AboutUsPageDataStore
{
    // VIP Properties
    var presenter: AboutUsPagePresentationLogic?
    var worker: AboutUsPageWorker?
    
    // State
    
    
    // Init
    init(request: AboutUsPageBuilder.BuildRequest) {
        
    }
}

// MARK: - Business
extension AboutUsPageInteractor {

}
