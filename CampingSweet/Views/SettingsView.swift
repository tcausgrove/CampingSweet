//
//  SettingsView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/20/23.
//

import SwiftUI
import Defaults

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Default(.settingsKey) var settings

    @State var defaultDistance: DistanceOptions = .mi
    @State var timeFormat: ClockHours = .two
    @State var dateFormat: DateFormatType = .monthFirst
    @State var locationFormat: LocationImportFormat = .dd
    @State var dateImportFormat: DateImportFormat = .startEnd

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Display").font(.headline)) {
                    Picker("Distance in", selection: $defaultDistance) {
                        ForEach(DistanceOptions.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
                    .onAppear(perform: {
                        defaultDistance = settings.chosenDistance
                    })
                    
                    // FIXME: This doesn't appear to be used anywhere
                    Picker("Time format", selection: $timeFormat) {
                        ForEach(ClockHours.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
                    .onAppear(perform: {
                        timeFormat = settings.chosenClockHours
                    })
                }
                
                Section(header: Text("CSV Import").font(.headline)) {
                    Picker("Location", selection: $locationFormat) {
                        ForEach(LocationImportFormat.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
                    .onAppear(perform: {
                        locationFormat = settings.locationImportFormat
                    })
                    
                    Picker("Date entries", selection: $dateImportFormat) {
                        ForEach(DateImportFormat.allCases) { option in
                            Text(option.rawValue)}
                    }
                    .onAppear(perform: {
                        dateImportFormat = settings.dateImportFormat
                    })
                    
                    Picker("Date format", selection: $dateFormat) {
                        ForEach(DateFormatType.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
                    .onAppear(perform: {
                        dateFormat = settings.chosenDateFormat
                    })
                }
            }
            .background(BackgroundView()).scrollContentBackground(.hidden)
            .onDisappear {
                settings.chosenDistance = defaultDistance
                settings.chosenClockHours = timeFormat
                settings.chosenDateFormat = dateFormat
                settings.locationImportFormat = locationFormat
                settings.dateImportFormat = dateImportFormat
            }
            .navigationTitle("User settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
