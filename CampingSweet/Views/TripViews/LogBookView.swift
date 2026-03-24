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
            HStack {
                LogBookCSVView(camper: localCamper!)
                    .disabled(localCamper == nil)
                
                Spacer()
                
                FilterButton()
                
                Spacer()
                
                Button(action: {
                    tripToEdit = nil
                    editingLogEntry.toggle()
                }) {
                    Image(systemName: "plus")
                }
            }
            .padding([.bottom, .leading, .trailing], 30)

            if localCamper != nil {
                LowerLogBookView(camperID: localCamper!.id, tripFilter: tripFilter)
            } else {
                ContentUnavailableView("No camper selected",
                                       systemImage: "exclamationmark.octagon",
                                       description: Text("Choose a camper to view their log book"))
            }
        }
        .background(BackgroundView()).scrollContentBackground(.hidden)
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
