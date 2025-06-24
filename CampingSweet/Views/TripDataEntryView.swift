//
//  TripDataEntryView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 11/18/24.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

struct TripDataEntryView: View {

    @Binding var title: String
    @Binding var start: Date
    @Binding var end: Date
    @Binding var distance: String
    @Binding var latitude: String
    @Binding var longitude: String
    
    @State private var numberOfNightsText: String = " "
    let getLocation = GetLocation()

    var body: some View {
        Form {
            Section(header: Text("Place")) {
                TextField("Destination", text: $title)
                let unit = "Distance (" //+ viewModel.getDistanceUnitFromSetting() + ")"
                TextField(unit, text: $distance)
                    .keyboardType(.decimalPad)
                    .numbersOnly($distance, includeDecimal: true, includeNegative: false)  // See NumbersOnlyViewModifier.swift
            }
            
            Section(header: Text("Geolocation")) {
                TextField("Latitude", text: $latitude)
                    .keyboardType(.numbersAndPunctuation)
                    .numbersOnly($latitude, includeDecimal: true, includeNegative: true)  // See NumbersOnlyViewModifier.swift
                TextField("Longitude", text: $longitude)
                    .keyboardType(.numbersAndPunctuation)
                    .numbersOnly($longitude, includeDecimal: true, includeNegative: true)  // See NumbersOnlyViewModifier.swift
                LocationButton {
                    readLocation()
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Section(header: Text("Dates")) {
                DatePicker("Arrival date", selection: $start, in: ...end, displayedComponents: [.date])
                    .onChange(of: start) {
//                        numberOfNightsText =
                    }
                
                DatePicker("Departure date", selection: $end, in: start..., displayedComponents: [.date])
                    .onChange(of: end) {
//                        numberOfNightsText = "4"
                    }
                
                Text(numberOfNightsText)
            }
        }
    }
    
    func readLocation() {
        getLocation.run {
            if let location = $0 {
                latitude = String(location.coordinate.latitude)
                longitude = String(location.coordinate.longitude)
            } else {
                print("Get Location failed \(String(describing: getLocation.didFailWithError))")
            }
        }
    }
}

#Preview {
    TripDataEntryView(title: .constant("Preview trip"),
                      start: .constant(Date.now),
                      end: .constant(Date.now),
                      distance: .constant("345.6"),
                      latitude: .constant("-45.6"),
                      longitude: .constant("-123.4") )
}
