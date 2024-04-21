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

//    @State var camper: Camper = Camper.example

    @State var defaultUnits: VolumeOptions = .america
    @State var defaultDistance: DistanceOptions = .mi
    @State var timeFormat: ClockHours = .two

    var body: some View {
        NavigationView {
            VStack {
                Text("User settings")
                    .font(.title2)
                    .padding(.bottom, 30)
                HStack {
                    Text("Volume")
                    Picker("Default Units", selection: $defaultUnits) {
                        ForEach(VolumeOptions.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
                    .onAppear(perform: {
                        defaultUnits = viewModel.settings.chosenUnits
                    })
                    .pickerStyle(.segmented)
                    .padding()
                }
                HStack {
                    Text("Distance")
                    Picker("Distance in", selection: $defaultDistance) {
                        ForEach(DistanceOptions.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
                    .onAppear(perform: {
                        defaultDistance = viewModel.settings.chosenDistance
                    })
                    .pickerStyle(.segmented)
                    .padding()
                }
                HStack {
                    Text("Time")
                    Picker("Time format", selection: $timeFormat) {
                        ForEach(ClockHours.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
                    .onAppear(perform: {
                        timeFormat = viewModel.settings.chosenClockHours
                    })
                    .pickerStyle(.segmented)
                    .padding()
                }
                Spacer()
            }
                .toolbar(){
                    ToolbarItemGroup(placement: .navigation) {
                        Button(role: .cancel, action: {
                            viewModel.changeSettings(
                                newChosenUnits: defaultUnits,
                                newChosenDistance: defaultDistance,
                                newClockHours: timeFormat)
                            dismiss() }) {
                            Text("Done")
                        }
                    }
                }
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
