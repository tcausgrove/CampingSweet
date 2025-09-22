//
//  DataModel.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import Foundation
import MapKit
import Defaults

struct Settings: Codable, Defaults.Serializable {
    var chosenDistance: DistanceOptions
    var chosenClockHours: ClockHours
    var chosenDateFormat: DateFormatType
    var locationImportFormat: LocationImportFormat
    var dateImportFormat: DateImportFormat
    
    static let example = Settings(chosenDistance: .mi,
                                  chosenClockHours: .two,
                                  chosenDateFormat: .monthFirst,
                                  locationImportFormat: .dd,
                                  dateImportFormat: .startEnd)
}
