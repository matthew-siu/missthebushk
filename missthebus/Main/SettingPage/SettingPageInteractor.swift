//
//  SettingPageInteractor.swift
//  missthebus
//
//  Created by Matthew Siu on 20/8/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - Requests from view
protocol SettingPageBusinessLogic
{
    func clearMemoryCache()
}

// MARK: - Datas retain in interactor defines here
protocol SettingPageDataStore
{
    
}

// MARK: - Interactor Body
class SettingPageInteractor: SettingPageBusinessLogic, SettingPageDataStore
{
    // VIP Properties
    var presenter: SettingPagePresentationLogic?
    var worker: SettingPageWorker?
    
    // State
    
    
    // Init
    init(request: SettingPageBuilder.BuildRequest) {
        
    }
}

// MARK: - Business
extension SettingPageInteractor {
    func clearMemoryCache() {
        Storage.remove(Configs.Storage.KEY_REMINDERS)
        Storage.remove(Configs.Storage.KEY_BOOKMARKS)
        Storage.remove(Configs.Storage.KEY_LANGUAGE)
    }
}
