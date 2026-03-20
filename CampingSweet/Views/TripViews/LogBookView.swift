//
//  LogBookView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI
import SwiftData
import Defaults

struct LogBookView: View {
    var localCamper: Camper?
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Default(.settingsKey) var settings
    @Default(.tripFilterKey) var tripFilter: FilterTrips
    
    @State private var editingLogEntry: Bool = false
    @State private var isExporting: Bool = false
    @State var tripToEdit: LogEntry? = nil
    
    var body: some View {
        VStack {
//            let camper = Camper.selectedCamperFromID(with: modelContext, selectedCamperID: localCamperID)
            if localCamper != nil {
                LowerLogBookView(camperID: localCamper!.id, tripFilter: tripFilter)
            } else {
                ContentUnavailableView("No camper selected",
                                       systemImage: "exclamationmark.octagon",
                                       description: Text("Choose a camper to view their log book"))
            }
        }
        .background(BackgroundView()).scrollContentBackground(.hidden)
        .toolbar() {
            ToolbarItem {
                Button(action: {
                    tripToEdit = nil
                    editingLogEntry.toggle()
                }) {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem {
                FilterButton()
            }
            ToolbarItem {
//                let camper = Camper.selectedCamperFromID(with: modelContext, selectedCamperID: localCamperID)
                LogBookCSVView(camper: localCamper!)
                    .disabled(localCamper == nil)
            }
        }
        .navigationTitle("Log Book")
        .sheet(isPresented: $editingLogEntry, content: {
            EditLogEntryView()
        })
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        LogBookView(localCamper: Camper.previewCamperA)
    }
}
