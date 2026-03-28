//
//  TripOptionsMenuView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 10/28/25.
//

import SwiftUI
import SwiftData
import Defaults

struct TripOptionsMenuView: View {
    var logEntry: LogEntry
    @Binding var editingLogEntry: Bool
    @Environment(\.modelContext) var modelContext
    @Default(.selectedCamperIDKey) var selectedCamperID
    
    var body: some View {
        Menu {
            Button(role: .destructive, action: { deleteTrip(trip: logEntry) }) {
                Text("Delete trip")
            }
            
            Button(action: {
                editingLogEntry = true
            }) {
                Text("Edit trip")
            }
            
            Button(action: { openMapAtLocation(logEntry: logEntry) }) {
                Text("Open in Maps")
            }
            .disabled((logEntry.latitude == nil) || (logEntry.longitude == nil))
        } label: {
            Text("Trip options")
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
    ModelContainerPreview(ModelContainer.sample) {
        TripOptionsMenuView(logEntry: Camper.previewCamperA.trips.first!, editingLogEntry: .constant(false))
    }
}
