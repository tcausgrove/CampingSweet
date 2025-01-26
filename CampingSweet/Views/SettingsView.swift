//
//  SettingsView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/20/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var defaultUnits: VolumeOptions = .america
    @State var defaultDistance: DistanceOptions = .mi
    @State var timeFormat: ClockHours = .two
    @State var dateFormat: DateFormatType = .monthFirst
    @State var locationFormat: LocationImportFormat = .dd
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Display")) {
                    
                    HStack {
                        Picker("Distance in", selection: $defaultDistance) {
                            ForEach(DistanceOptions.allCases) { option in
                                Text(option.rawValue)
                            }
                        }
                        .onAppear(perform: {
                            defaultDistance = viewModel.settings.chosenDistance
                        })
                    }
                    
                    HStack {
                        Picker("Time format", selection: $timeFormat) {
                            ForEach(ClockHours.allCases) { option in
                                Text(option.rawValue)
                            }
                        }
                        .onAppear(perform: {
                            timeFormat = viewModel.settings.chosenClockHours
                        })
                    }
                    
                    HStack {
                        Picker("Date format", selection: $dateFormat) {
                            ForEach(DateFormatType.allCases) { option in
                                Text(option.rawValue)
                            }
                        }
                        .onAppear(perform: {
                            timeFormat = viewModel.settings.chosenClockHours
                        })
                    }
                }
                Section(header: Text("CSV Import")) {
                    Picker("Location", selection: $locationFormat) {
                        ForEach(LocationImportFormat.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
                    .onAppear(perform: {
                        locationFormat = viewModel.settings.locationImportFormat
                    })

                }
            }
            .toolbar(){
                ToolbarItemGroup(placement: .navigation) {
                    Button(role: .cancel, action: {
                        viewModel.changeSettings(newChosenDistance: defaultDistance,
                                                 newClockHours: timeFormat,
                                                 newDateFormat: dateFormat,
                                                 newLocationFormat: locationFormat)
                        dismiss() }) {
                            Text("Done")
                        }
                }
            }
            .navigationTitle("User settings")
            .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ViewModel())
    }
}
