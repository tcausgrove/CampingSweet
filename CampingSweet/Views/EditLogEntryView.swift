//
//  EditLogEntryView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 11/18/24.
//

import SwiftUI
import SwiftData

struct EditLogEntryView: View {
    
    var previousLogEntry: SwiftDataLogEntry?

    @State var title: String = ""
    @State var start: Date = Date.now
    @State var end: Date = Date.now
    @State var distance: String = ""
    @State var latitude: String = ""
    @State var longitude: String = ""

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
                                  distance: $distance,
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
        let camper = SwiftDataCamper.selectedCamper(with: modelContext)
        if let previousLogEntry {
            // Edit the trip
            previousLogEntry.title = title
            previousLogEntry.distance = Double(distance)
            previousLogEntry.startDate = start
            previousLogEntry.endDate = end
            previousLogEntry.latitude = Double(latitude) ?? 0.0
            previousLogEntry.longitude = Double(longitude) ?? 0.0
        } else {
            // Add a new trip
            let newLogEntry = SwiftDataLogEntry(title: title,
                                               distance: Double(distance),
                                                startDate: start,
                                                endDate: end,
                                                latitude: Double(latitude) ?? 0.0,
                                                longitude: Double(longitude) ?? 0.0)
            camper.trips.append(newLogEntry)
        }
    }
    
    func populateVariables() {
        if let previousLogEntry {
            title = previousLogEntry.title
            start = previousLogEntry.startDate
            end = previousLogEntry.endDate
            let newDistance: Double = previousLogEntry.distance ?? 0.0
            distance = String(newDistance)
            let newLatitude: Double? = previousLogEntry.latitude
            let newLongitude: Double? = previousLogEntry.longitude
            if newLatitude != nil { latitude = String(newLatitude!) }
            if newLongitude != nil { longitude = String(newLongitude!) }
        }
    }
}

#Preview {
    EditLogEntryView(previousLogEntry: SwiftDataLogEntry(title: "Preview", distance: 12.3))
//    EditLogEntryView(previousLogEntry: nil)
}
