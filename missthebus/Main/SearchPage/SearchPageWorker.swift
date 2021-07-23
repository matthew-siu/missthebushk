//
//  SearchPageWorker.swift
//  missthebus
//
//  Created by Matthew Siu on 7/7/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchPageWorker
{

    static func getAllRoutes(completion: @escaping ((KmbRouteResponse?, Error?) -> ())) {
        
        SVProgressHUD.dismiss()
        SVProgressHUD.show()
        
        let repo = KmbRouteAPIRepository()
        KMBAPI.send(repository: repo)
            .done { (response) in
                SVProgressHUD.dismiss()
                if let ref = response.body  {
                    completion(ref, nil)
                } else {
                    completion(nil, nil)
                }
            }
            .catch { (error) in
                SVProgressHUD.dismiss()
                completion(nil, error)
        }
    }
}
