//
//  LanguagePageInteractor.swift
//  missthebus
//
//  Created by Matthew Siu on 20/8/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Requests from view
protocol LanguagePageBusinessLogic
{
    
}

// MARK: - Datas retain in interactor defines here
protocol LanguagePageDataStore
{
    
}

// MARK: - Interactor Body
class LanguagePageInteractor: LanguagePageBusinessLogic, LanguagePageDataStore
{
    // VIP Properties
    var presenter: LanguagePagePresentationLogic?
    var worker: LanguagePageWorker?
    
    // State
    
    
    // Init
    init(request: LanguagePageBuilder.BuildRequest) {
        
    }
}

// MARK: - Business
extension LanguagePageInteractor {

}
