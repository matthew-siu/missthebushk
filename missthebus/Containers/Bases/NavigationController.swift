//
//  NavigationController.swift
//  Webscanner
//
//  Created by Matthew Siu on 11/6/2021.
//

import UIKit

class NavigationController: UINavigationController {
    enum NavigationBarStyle {
        case `default`
        case transparent
        case light
        
        var titleTextColor: Color {
            switch self {
            case .default:
                return Color.white
            case .transparent:
                return Color.darkGrey
            case .light:
                return Color.darkGrey
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .default:
                return Color.darkBlue
            default:
                return Color.white
            }
        }
    }
    
    // Private config
//    var transparentBar: Bool = false
    var navigationBarStyle: NavigationBarStyle = .transparent
    
    // Init
    init(rootViewController: UIViewController, navigationBarStyle: NavigationBarStyle = .transparent) {
        super.init(rootViewController: rootViewController)
        self.navigationBarStyle = navigationBarStyle

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    // Navigation bar transparent logic
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        switch self.navigationBarStyle {
        case .default:
            self.navigationBar.tintColor = Color.white.uiColor
            self.navigationBar.isTranslucent = false
            self.navigationBar.barTintColor = self.navigationBarStyle.backgroundColor.uiColor
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: self.navigationBarStyle.titleTextColor.uiColor, NSAttributedString.Key.font: TextStyle.subhead1.font]
        case .transparent:
            self.navigationBar.tintColor = Color.black.uiColor
            self.navigationBar.isTranslucent = true
            self.navigationBar.backgroundColor = UIColor.clear
            self.navigationBar.barTintColor = UIColor.clear
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.shadowImage = UIImage()
        case .light:
            self.navigationBar.tintColor = Color.black.uiColor
            self.navigationBar.isTranslucent = false
            self.navigationBar.barTintColor = self.navigationBarStyle.backgroundColor.uiColor
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: self.navigationBarStyle.titleTextColor.uiColor, NSAttributedString.Key.font: TextStyle.subhead1.font]
        }
    }
}

extension UINavigationController {
    func popViewController(animated:Bool, completion: @escaping ()->()) {
        print("pop")
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animated)
        CATransaction.commit()
    }
}
