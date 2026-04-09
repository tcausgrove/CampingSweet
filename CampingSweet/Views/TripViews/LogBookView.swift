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
    @Default(.selectedCamperIDKey) var selectedCamperID

    @State private var editingLogEntry: Bool = false
    @State private var isExporting: Bool = false
    @State var tripToEdit: LogEntry? = nil
    @State var years: [String] = []
    @State var yearToShow: String = "All years"
    @State var camperName: String = ""

    var body: some View {
        VStack {
            HStack {
                if localCamper != nil {
                    LogBookCSVView(camper: localCamper!)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                SelectYearButton(years: years, yearToShow: $yearToShow)
                    .frame(maxWidth: .infinity, alignment: .center)
 
                Button(action: {
                    tripToEdit = nil
                    editingLogEntry.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding([.bottom, .leading, .trailing], 20)

            if localCamper != nil {
                LowerLogBookView(yearSelection: yearToShow, camperName: camperName)
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
        .onAppear(perform: { // Get the list of years to be listed in the picker
            let camper = Camper.selectedCamperFromID(with: modelContext, selectedCamperID: selectedCamperID)
            years = camper?.yearsUsed ?? ["Not available"]
            camperName = camper?.name ?? "Not available"
        })
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        LogBookView(localCamper: Camper.previewCamperA)
    }
}
