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
    @EnvironmentObject var viewModel: ViewModel

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
                
                // FIXME:  Settings aren't being used
                let unit = "Distance (" + viewModel.getDistanceUnitFromSetting() + ")"
                TextField(unit, text: $distance)
                    .keyboardType(.decimalPad)
                // FIXME:  Need to do a test on numbersOnly, it prevents display
//                    .numbersOnly($distance, includeDecimal: true, includeNegative: false)  // See NumbersOnlyViewModifier.swift
            }
            
            Section(header: Text("Geolocation")) {
                TextField("Latitude", text: $latitude)
                    .keyboardType(.numbersAndPunctuation)
//                    .numbersOnly($latitude, includeDecimal: true, includeNegative: true)  // See NumbersOnlyViewModifier.swift
                TextField("Longitude", text: $longitude)
                    .keyboardType(.numbersAndPunctuation)
//                    .numbersOnly($longitude, includeDecimal: true, includeNegative: true)  // See NumbersOnlyViewModifier.swift
                LocationButton {
                    readLocation()
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Section(header: Text("Dates")) {
                DatePicker("Arrival date", selection: $start, in: ...end, displayedComponents: [.date])
                    .onChange(of: start) {
                        numberOfNightsText = startEndDateToNights(startDate: start, endDate: end)
                    }
                
                DatePicker("Departure date", selection: $end, in: start..., displayedComponents: [.date])
                    .onChange(of: end) {
                        numberOfNightsText = startEndDateToNights(startDate: start, endDate: end)
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
    @Previewable @State var title = "Preview trip"
    @Previewable @State var start = Date.now
    @Previewable @State var end = Date.now
    @Previewable @State var distance: String = "123.4"
    @Previewable @State var latitude: String = "-45.6"
    @Previewable @State var longitude: String = "-123.4"

    TripDataEntryView(title: $title,
                              start: $start,
                              end: $end,
                              distance: $distance,
                              latitude: $latitude,
                              longitude: $longitude )
    .environmentObject(ViewModel())
}
