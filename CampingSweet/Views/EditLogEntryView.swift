//
//  EditLogEntryView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 11/18/24.
//

import SwiftUI

struct EditLogEntryView: View {
    
    @Binding var previousLogEntry: LogEntry?
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var start: Date = Date()
    @State private var end: Date = Date()
    @State private var distance: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if previousLogEntry == nil {
                    Text( "Add Log Book Entry" )
                        .padding(.bottom, 30)
                        .font(.title)
                } else {
                    Text( "Edit Log Book Entry" )
                        .padding(.bottom, 30)
                        .font(.title)
                }
                
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
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", role: .none, action: {
                        saveLogBookEntry()
                        dismiss()
                    })
                }
            }
            .onAppear(perform: { populateVariables() })
        }
    }
    
    func populateVariables() {
        if previousLogEntry == nil { // We are adding a new entry
            
        } else {
            title = previousLogEntry!.title
            start = previousLogEntry!.startDate
            end = previousLogEntry!.endDate
            let newDistance: Double = previousLogEntry!.distance!
            distance = String(newDistance)
            let newLatitude: Double? = previousLogEntry!.latitude
            let newLongitude: Double? = previousLogEntry!.longitude
            if newLatitude != nil { latitude = String(newLatitude!) }
            if newLongitude != nil { longitude = String(newLongitude!) }
        }
    }
    
    func saveLogBookEntry() {
        if previousLogEntry == nil {
            viewModel.addTrip(title: title, startDate: start, endDate: end, distance: distance, latitude: latitude, longitude: longitude)
            return
        }
        let theTripID = previousLogEntry?.id ?? UUID()
        viewModel.editTrip(tripID: theTripID,
                           title: title, startDate: start,
                           endDate: end, distance: distance,
                           latitude: latitude,
                           longitude: longitude)
    }
}

#Preview {
    EditLogEntryView(previousLogEntry: .constant(LogEntry.example))
        .environmentObject(ViewModel())
}
