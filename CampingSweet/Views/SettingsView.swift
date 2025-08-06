//
//  SettingsView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/20/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var defaultDistance: DistanceOptions = .mi
    @State var timeFormat: ClockHours = .two
    @State var dateFormat: DateFormatType = .monthFirst
    @State var locationFormat: LocationImportFormat = .dd
    @State var dateImportFormat: DateImportFormat = .startEnd

    var body: some View {
            Form {
                Section(header: Text("Display").font(.headline)) {
                        Picker("Distance in", selection: $defaultDistance) {
                            ForEach(DistanceOptions.allCases) { option in
                                Text(option.rawValue)
                            }
                        }
                        .onAppear(perform: {
                            defaultDistance = viewModel.settings.chosenDistance
                        })
                    
                    // FIXME: This doesn't appear to be used anywhere
                        Picker("Time format", selection: $timeFormat) {
                            ForEach(ClockHours.allCases) { option in
                                Text(option.rawValue)
                            }
                        }
                        .onAppear(perform: {
                            timeFormat = viewModel.settings.chosenClockHours
                        })
                    // FIXME: This doesn't appear to be used anywhere
                        Picker("Date format", selection: $dateFormat) {
                            ForEach(DateFormatType.allCases) { option in
                                Text(option.rawValue)
                            }
                        }
                        .onAppear(perform: {
                            dateFormat = viewModel.settings.chosenDateFormat
                        })
                    }

                Section(header: Text("CSV Import").font(.headline)) {
                    Picker("Location", selection: $locationFormat) {
                        ForEach(LocationImportFormat.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
                    .onAppear(perform: {
                        locationFormat = viewModel.settings.locationImportFormat
                    })

                    Picker("Date entries", selection: $dateImportFormat) {
                        ForEach(DateImportFormat.allCases) { option in
                            Text(option.rawValue)}
                    }
                    .onAppear(perform: {
                        dateImportFormat = viewModel.settings.dateImportFormat
                    })
                }
            }
            .onDisappear {
                viewModel.changeSettings(newChosenDistance: defaultDistance,
                                         newClockHours: timeFormat,
                                         newDateFormat: dateFormat,
                                         newLocationFormat: locationFormat,
                                         newDateImportFormat: dateImportFormat)
            }
            .navigationTitle("User settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ViewModel())
    }
}
