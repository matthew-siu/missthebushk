//
//  LanguageConfigs.swift
//  clp-rollcall
//
//  Created by Ding Lo on 28/7/2020.
//  Copyright © 2020 Ding Lo. All rights reserved.
//

import Foundation

// MARK: - Entrance point of getting current language
var currentLanguage: AppLanguage {
    return AppLanguage.currentLanguage
}

public enum AppLanguage: String {
    case english = "en"
    case traditionalChinese = "zh-HK"
    case simplifiedChinese = "zh-Hans"
}

// MARK: - Constant
extension AppLanguage {
    public static let allLanguages: [AppLanguage] = [.english, .traditionalChinese, .simplifiedChinese]
    public static let defaultLanguage = AppLanguage.english
    
    static var currentLanguage: AppLanguage {
        get {
            var lang = Storage.getString(suiteName: Configs.SuiteName.AppGroup, Configs.Storage.KEY_LANGUAGE)
            if (lang == "") {
                lang = NSLocale.preferredLanguages[0]
            }
            if (lang.hasPrefix(AppLanguage.english.rawValue)){
                return AppLanguage.english
            }else if (lang.hasPrefix(AppLanguage.simplifiedChinese.rawValue)){
                return AppLanguage.simplifiedChinese
            }else if (lang.hasPrefix("zh")){
                return AppLanguage.traditionalChinese
            }
            return AppLanguage.defaultLanguage
        }
        set {
            // update app language through legacy Language Handler
            if self.currentLanguage == newValue { return }
            Storage.save(suiteName: Configs.SuiteName.AppGroup, Configs.Storage.KEY_LANGUAGE, self.currentLanguage.rawValue)
        }

    }
}

extension String {
    
    func localized() ->String {
        let path = Bundle(for: ViewController.self).path(forResource: currentLanguage.rawValue, ofType: "lproj")

        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
