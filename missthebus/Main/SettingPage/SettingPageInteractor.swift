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
    func reloadInfo()
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
        Storage.remove(suiteName: Configs.SuiteName.AppGroup, Configs.Storage.KEY_BOOKMARKS)
    }
    
    func reloadInfo(){
        Storage.remove(Configs.Storage.KEY_LAST_UPDATE)
        Storage.remove(Configs.Storage.KEY_ROUTES)
        Storage.remove(Configs.Storage.KEY_ROUTESTOPS)
        Storage.remove(suiteName: Configs.SuiteName.AppGroup, Configs.Storage.KEY_STOPS)
        
        let request = SplashScreenBuilder.BuildRequest()
        let vc = SplashScreenBuilder.createScene(request: request)
        guard let window = UIApplication.shared.windows.first else{
            return
        }
        let navVC = NavigationController(rootViewController: vc)
        window.rootViewController = navVC
    }
}
