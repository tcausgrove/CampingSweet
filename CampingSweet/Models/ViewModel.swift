//
//  ViewModel.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI

@MainActor class ViewModel: ObservableObject {
    @Published private(set) var settings = Settings.example
    @Published var userError: UserError? = nil
    
    
    init() {
        
        if let data = UserDefaults.standard.data(forKey: "settings") {
            if let decoded = try? JSONDecoder().decode(Settings.self, from: data) {
                settings = decoded
                userError = nil
            } else {
                settings = Settings.example
                userError = UserError.settingsNotFound
            }
        }
    }
    
    func changeSettings(newChosenDistance: DistanceOptions,
                        newClockHours: ClockHours,
                        newDateFormat: DateFormatType,
                        newLocationFormat: LocationImportFormat,
                        newDateImportFormat: DateImportFormat) {
        
        self.settings.chosenDistance = newChosenDistance
        self.settings.chosenClockHours = newClockHours
        self.settings.chosenDateFormat = newDateFormat
        self.settings.locationImportFormat = newLocationFormat
        self.settings.dateImportFormat = newDateImportFormat
        
        save()
    }
    
    func save() {
        do {
            let encodedSettings = try JSONEncoder().encode(settings)
            UserDefaults.standard.set(encodedSettings, forKey: "settings")
            userError = nil
        } catch {
            userError = UserError.settingsNotFound
        }
    }
    
    func convertDoubleBySetting(distance: Double) -> Measurement<UnitLength> {
        var formattedDistance: Measurement<UnitLength> = Measurement(value: 0.0, unit: UnitLength.meters)
        
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
}

