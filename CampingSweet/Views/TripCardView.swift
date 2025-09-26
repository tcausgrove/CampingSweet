//
//  TripCardView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/9/25.
//

import SwiftUI
import SwiftData
import Defaults


struct TripCardView: View {
    var logEntry: LogEntry
    
    @Default(.selectedCamperIDKey) var selectedCamperID
    @Default(.settingsKey) var settings
    @Environment(\.modelContext) var modelContext
    @State private var editingLogEntry: Bool = false

    var body: some View {
        CardView(backgroundColor: Color.sheetButtonBackground) {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("Title:  \(logEntry.title)")
                    
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
                Text("When:  \(logEntry.startDate.formatted(date: .long, time: .omitted))")
                let numberOfNightsText = "Number of nights:  " + String(logEntry.numberOfNights)
                Text(numberOfNightsText)
                
                let tripDistance = logEntry.distance ?? 0.0
                HStack {
                    if tripDistance > 0.1 {
                        Text("Distance: " + formatDistanceBySetting(distance: tripDistance))
                    }
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $editingLogEntry, content: {
            EditLogEntryView(previousLogEntry: logEntry )
        })

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
    TripCardView(logEntry: LogEntry(title: "Preview trip", distance: 666.0))
}
