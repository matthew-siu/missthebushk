//
//  StringExtension.swift
//  autotoll-build-release
//
//  Created by Ding Lo on 17/2/2021.
//

import Foundation

extension String {
    enum GetStringType {
        case before
        case after
    }
    
    func getStringRange(needle: String, area: GetStringType) -> String {
        guard let index = self.range(of: needle) else { return "" }

        switch area {
        case .before:
            return String(self[...index.lowerBound]).trimmingCharacters(in: .whitespaces)
        case .after:
            return String(self[index.upperBound...]).trimmingCharacters(in: .whitespaces)
        }
    }
    
    func toTimestamp(dateFormat: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self)
        return Int(date!.timeIntervalSince1970)
    }
    
    func toDate(dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self)
    }
    
    func covertDateFormatter(from: String, to: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = from
        let date = dateFormatter.date(from: self)
        
        guard let formatterDate = date else { return nil }
        dateFormatter.dateFormat = to
        let dateString = dateFormatter.string(from: formatterDate)
        return dateString
    }

}
