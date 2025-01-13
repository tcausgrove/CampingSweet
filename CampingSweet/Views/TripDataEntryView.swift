//
//  TripDataEntryView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 11/18/24.
//

import SwiftUI

struct TripDataEntryView: View {
    
    @EnvironmentObject var viewModel: ViewModel

    @Binding var title: String
    @Binding var start: Date
    @Binding var end: Date
    @Binding var distance: String
    @Binding var latitude: String
    @Binding var longitude: String
    
    @State private var numberOfNightsText: String = " "

    var body: some View {
        Form {
            Section(header: Text("Place")) {
                TextField("Destination", text: $title)
                let unit = "Distance (" + viewModel.getDistanceUnitFromSetting() + ")"
                TextField(unit, text: $distance)
                    .keyboardType(.decimalPad)
                    .numbersOnly($distance, includeDecimal: true)  // See NumbersOnlyViewModifier.swift
            }
            
            Section(header: Text("Geolocation")) {
                TextField("Latitude", text: $latitude)
                TextField("Longitude", text:$longitude)
                Button( action: { } ) { Text("Set to current location") }
            }

            Section(header: Text("Dates")) {
                DatePicker("Arrival date", selection: $start, displayedComponents: [.date])
                    .onChange(of: start, perform: { _ in
                        numberOfNightsText = viewModel.setDisplayedNightsText(start: start, end: end) })
                
                DatePicker("Departure date", selection: $end, in: start..., displayedComponents: [.date])
                    .onChange(of: end, perform: { _ in
                        numberOfNightsText = viewModel.setDisplayedNightsText(start: start, end: end) })
                
                Text(numberOfNightsText)
            }
        }
    }
}

