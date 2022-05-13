//
//  WidgetStopETA.swift
//  missthebus
//
//  Created by Matthew Siu on 12/5/2022.
//

import Foundation

struct WidgetBusStopETA: Codable, Identifiable{
    let id: UUID
    let busNum: String
    let stopName: String
    let eta1: String?
    let eta2: String?
}
