//
//  TableViewCellHelper.swift
//  clp-rollcall
//
//  Created by Ding Lo on 28/7/2020.
//  Copyright © 2020 Ding Lo. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Main purpose is to help configuration cell initialization in a faster and centralized way
protocol TableViewCellConfiguration: RawRepresentable where Self.RawValue == String {}

protocol CollectionViewCellConfiguration: TableViewCellConfiguration {}

extension TableViewCellConfiguration {
    var nib: UINib? {
        return UINib(nibName: self.rawValue, bundle: nil)
    }
    
    var reuseId: String {
        return self.rawValue
    }
}
