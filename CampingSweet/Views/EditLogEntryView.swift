//
//  EditLogEntryView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 11/18/24.
//

import SwiftUI
import SwiftData
import CoreLocation

struct EditLogEntryView: View {
    @EnvironmentObject var viewModel: ViewModel

    var previousLogEntry: SwiftDataLogEntry?

    @State var title: String = ""
    @State var start: Date = Date.now
    @State var end: Date = Date.now
    @State var distance: Measurement<UnitLength> = .init(value: 1.0, unit: .miles)
//    @State var location: CLLocationCoordinate2D
    @State var latitude: String = ""
    @State var longitude: String = ""
    
    @State var distanceString = ""

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    private var editorTitle: String {
        previousLogEntry == nil ? "Add Trip" : "Edit Trip"
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TripDataEntryView(title: $title,
                                  start: $start,
                                  end: $end,
                                  distanceString: $distanceString,
                                  latitude: $latitude,
                                  longitude: $longitude)
            }
            .padding()
            .toolbar() {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: { dismiss() })
                }
                ToolbarItem(placement: .principal) {
                    Text(editorTitle)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", role: .none, action: {
                        saveLogBookEntry()
                        dismiss()
                    })
                }
            }
        }
        .onAppear(){
            populateVariables()
        }

    }
    
    func saveLogBookEntry() {
        distance = Measurement(value: Double(distanceString) ?? 0.0, unit: viewModel.settings.chosenDistance.unit)
        let camper = SwiftDataCamper.selectedCamper(with: modelContext)
        if let previousLogEntry {
            // Edit the trip
            previousLogEntry.title = title
            previousLogEntry.drivingDistanceMiles = distance
            previousLogEntry.startDate = start
            previousLogEntry.endDate = end
            previousLogEntry.latitude = Double(latitude) ?? 0.0
            previousLogEntry.longitude = Double(longitude) ?? 0.0
        } else {
            // Add a new trip
            let newLogEntry = SwiftDataLogEntry(title: title,
                                                distance: distance.converted(to: .miles).value,
                                                startDate: start,
                                                endDate: end,
                                                latitude: Double(latitude) ?? 0.0,
                                                longitude: Double(longitude) ?? 0.0,
                                                camper: camper)
            camper.trips.append(newLogEntry)
        }
    }
    
     func populateVariables() {
         if let previousLogEntry {
             title = previousLogEntry.title
             start = previousLogEntry.startDate
             end = previousLogEntry.endDate
//             let newDistance: Double = previousLogEntry.distance ?? 0.0
             distance = previousLogEntry.drivingDistanceMiles ?? .init(value: 0.0, unit: .miles)
             distanceString = String(format: "%.1f", distance.value)
             let newLatitude: Double? = previousLogEntry.latitude
             let newLongitude: Double? = previousLogEntry.longitude
             if newLatitude != nil { latitude = String(newLatitude!) }
             if newLongitude != nil { longitude = String(newLongitude!) }
         }
     }
}

#Preview {
    // PREVIEW IS NOT OPERATIONAL:  There is a problem with LocationButton
//    EditLogEntryView(previousLogEntry: SwiftDataLogEntry(title: "Preview", distance: 12.3, latitude: 123.45678, longitude: -46.34567))
    EditLogEntryView(previousLogEntry: nil)
        .environmentObject(ViewModel())
}
