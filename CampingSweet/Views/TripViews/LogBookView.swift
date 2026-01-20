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
    var localCamperID: UUID
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Default(.settingsKey) var settings
    @Default(.tripFilterKey) var tripFilter: FilterTrips

    @State private var editingLogEntry: Bool = false
    @State private var isExporting: Bool = false
    @State var tripToEdit: LogEntry? = nil
    
    var body: some View {
//        ZStack {
//            BackgroundView()
            VStack {
//                Text("Log Book")
//                    .font(.title)
//                    .padding(-10)
                let camper = Camper.selectedCamperFromID(with: modelContext, selectedCamperID: localCamperID)
                if camper != nil {
//                    LogBookCSVView(camper: camper!)
//                        .padding(12)
                    LowerLogBookView(camperID: camper!.id, tripFilter: tripFilter)
                } else {
                    ContentUnavailableView("No camper selected",
                                           systemImage: "exclamationmark.octagon",
                                           description: Text("Choose a camper to view their log book"))
                }
            }
            .background(BackgroundView()).scrollContentBackground(.hidden)
            .navigationTitle("Log Book")
//        }
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
                let camper = Camper.selectedCamperFromID(with: modelContext, selectedCamperID: localCamperID)
                LogBookCSVView(camper: camper!)
                    .disabled(camper == nil)
            }
        }
        .sheet(isPresented: $editingLogEntry, content: {
            EditLogEntryView()
        })
//        .navigationTitle("Log Book")
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        LogBookView(localCamperID: Camper.previewCamperA.id)
    }
}
