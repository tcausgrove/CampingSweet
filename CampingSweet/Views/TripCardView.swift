//
//  TripCardView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/9/25.
//

import SwiftUI
import SwiftData


struct TripCardView: View {
    var logEntry: SwiftDataLogEntry
    
    @AppSettings(\.settingsSelectedCamperName) var selectedCamperName
    @EnvironmentObject var viewModel: ViewModel
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
                        Text("Distance: " + viewModel.formatDistanceBySetting(distance: tripDistance))
                    }
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $editingLogEntry, content: {
            EditLogEntryView()
        })

    }
    
    func deleteTrip(trip: SwiftDataLogEntry) {
        let camper = SwiftDataCamper.selectedCamperFromName(with: modelContext, selectedCamperName: selectedCamperName)
        if camper != nil {
            guard let index = camper!.trips.firstIndex(of: trip) else {
            print("Why is there not a trip?")
            return
        }
            camper!.trips.remove(at: index)
        }
    }
}

#Preview {
    TripCardView(logEntry: SwiftDataLogEntry(title: "Preview trip", distance: 666.0))
        .environmentObject(ViewModel())
}
