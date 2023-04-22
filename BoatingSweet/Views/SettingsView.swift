//
//  SettingsView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/20/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss

    @State var boat: Boat = Boat.example

    @State private var defaultPort: String = ""
    @State private var defaultBoat: String = ""
    @State var defaultUnits: UnitOptions = .america
    @State var defaultDistance: DistanceOptions = .mi
    @State var timeFormat: ClockHours = .two
    
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            VStack {
                Text("User settings")
                    .font(.title2)
                    .padding(.bottom, 30)
                TextField("Default Home Port", text: $defaultPort)
                Picker("Boat", selection: $boat) {
                    ForEach(viewModel.boats, id: \.self) { boat in
                        Text(boat.name)
                    }
                }
                HStack {
                    Text("Units")
                    Picker("Default Units", selection: $defaultUnits) {
                        ForEach(UnitOptions.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
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
                    .pickerStyle(.segmented)
                    .padding()
                }
                Spacer()
            }
                .toolbar(){
                    ToolbarItemGroup(placement: .navigation) {
                        Button(role: .cancel, action: {
                            viewModel.changeSettings(
                                newHomePort: defaultPort,
                                newSelectedBoatID: UUID(),
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

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(boat: Boat.example)
//    }
//}
