//
//  TripListView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 9/29/25.
//

import SwiftUI
import Defaults

struct TripListView: View {
    var logEntry: LogEntry
    
    @Default(.selectedCamperIDKey) var selectedCamperID
    @Default(.settingsKey) var settings
    @Environment(\.modelContext) var modelContext
    @State private var editingLogEntry: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text("\(logEntry.title)")
                    .lineLimit(1)
                
                Spacer()
                
                Menu {
                    Button(role: .destructive, action: { deleteTrip(trip: logEntry) }) {
                        Text("Delete trip")
                    }
                    Button(action: {
                        editingLogEntry = true
                    }) {
                        Text("Edit trip")                       }
                } label: {
                    Text("Trip options")
                }
                
            }
            .padding(8)
            
            Divider()
        }
    }
    
    func deleteTrip(trip: LogEntry) {
        let camper = Camper.selectedCamperFromID(with: modelContext, selectedCamperID: selectedCamperID)
        if camper != nil {
            guard let index = camper!.trips.firstIndex(of: trip) else {
            return
        }
            camper!.trips.remove(at: index)
            try? modelContext.save()
        }
    }
}

#Preview {
    TripListView(logEntry: LogEntry(title: "Preview trip", distance: 666.0))
}
