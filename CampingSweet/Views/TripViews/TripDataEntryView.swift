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
    @Binding var distanceString: String
    @Binding var latitude: String
    @Binding var longitude: String
    
    @State private var numberOfNightsText: String? = nil
    let getLocation = GetLocation()

    var body: some View {
        Form {
            Section(header: Text("Place")) {
                TextField("Destination", text: $title)                
                DrivingDistanceView(distanceString: $distanceString)
            }
            
            Section(header: Text("Geolocation")) {
                TextField("Latitude", text: $latitude)
                    .keyboardType(.numbersAndPunctuation)
                    .numbersOnly($latitude, includeDecimal: true, includeNegative: true, digitAllowedAfterDecimal: 6)  // See NumbersOnlyViewModifier.swift
                TextField("Longitude", text: $longitude)
                    .keyboardType(.numbersAndPunctuation)
                    .numbersOnly($longitude, includeDecimal: true, includeNegative: true, digitAllowedAfterDecimal: 6)  // See NumbersOnlyViewModifier.swift
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
                
                if numberOfNightsText != nil {
                    Text(numberOfNightsText!)
                }
            }
        }
    }
    
    func readLocation() {
        getLocation.run {
            if let location = $0 {
                latitude = String(location.coordinate.latitude)
                longitude = String(location.coordinate.longitude)
            } else {
                //FIXME:  Should there be an error here?
            }
        }
    }
}


#Preview {
    @Previewable @State var title = "Preview trip"
    @Previewable @State var start = Date.now
    @Previewable @State var end = Date.now
    @Previewable @State var distanceString: String = "123.4"
//    @Previewable @State var location = CLLocationCoordinate2DMake(123.456, -45.678)
//    @Previewable @State var distance: Measurement<UnitLength> = .init(value: 123.4, unit: .miles)
    @Previewable @State var latitude: String = "-45.6"
    @Previewable @State var longitude: String = "-123.4"
    
    @Previewable @State var numberOfNightsText = "1 night"

    TripDataEntryView(title: $title,
                              start: $start,
                              end: $end,
                              distanceString: $distanceString,
                              latitude: $latitude,
                              longitude: $longitude )
}
