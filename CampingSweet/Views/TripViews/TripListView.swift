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
    
    @Default(.settingsKey) var settings
    @Environment(\.modelContext) var modelContext
    @State private var editingLogEntry: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text("\(logEntry.title)")
                    .lineLimit(1)
                
                Spacer()
                
                TripOptionsMenuView(logEntry: logEntry, editingLogEntry: $editingLogEntry)
            }
            .padding(8)
            
            Divider()
        }
        .sheet(isPresented: $editingLogEntry, content: {
            EditLogEntryView(previousLogEntry: logEntry )
        })

    }
}

#Preview {
    TripListView(logEntry: LogEntry(title: "Preview trip", distance: 666.0))
}
