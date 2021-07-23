//
//  CodableExtension.swift
//  clp-rollcall
//
//  Created by Ding Lo on 28/7/2020.
//  Copyright © 2020 Ding Lo. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        let encoder = JSONEncoder()
        
        // encodable to json data / also know as json object
        guard let data = try? encoder.encode(self) else { return nil }
        
        // json data to dictionary
        guard let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return nil }
        
        return jsonDictionary
    }
}
