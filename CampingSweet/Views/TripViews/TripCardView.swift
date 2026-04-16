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
    
    @Default(.settingsKey) var settings
    @Environment(\.modelContext) var modelContext
    @State private var editingLogEntry: Bool = false

    var body: some View {
        CardView(backgroundColor: Color.sheetButtonBackground) {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("Title:  \(logEntry.title)")
                        .lineLimit(1)
                    
                    Spacer()
                    
                    TripOptionsMenuView(logEntry: logEntry, editingLogEntry: $editingLogEntry)
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
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        TripCardView(logEntry: Camper.previewCamperA.trips.first!)
    }
}
