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

func convertDoubleBySetting(distance: Double) -> Measurement<UnitLength> {
    var formattedDistance: Measurement<UnitLength> = Measurement(value: 0.0, unit: UnitLength.meters)
    
    let settings = Defaults[.settingsKey]
    switch settings.chosenDistance {
    case .mi:
        formattedDistance = Measurement(value: distance, unit: UnitLength.miles)
    case .km:
        formattedDistance = Measurement(value: distance, unit: UnitLength.miles).converted(to: UnitLength.kilometers)
    case .nm:
        formattedDistance = Measurement(value: distance, unit: UnitLength.miles).converted(to: UnitLength.nauticalMiles)
    }
    return formattedDistance
}

func formatDistanceBySetting(distance: Double) -> String {
    let formattedDistance = convertDoubleBySetting(distance: distance)
    let unitFormatter = UnitFormatter()
    
    return unitFormatter.formatter.string(from: formattedDistance)
}

func getDistanceUnitFromSetting() -> String {
    let arbitraryNumber = 12.3
    let formattedDistance = convertDoubleBySetting(distance: arbitraryNumber)
    let unitFormatter = UnitFormatter()
    
    let unit = unitFormatter.formatter.string(from: formattedDistance.unit)
    
    return unit
}

