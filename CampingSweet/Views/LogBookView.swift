//
//  LogBookView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI
import SwiftData

struct LogBookView: View {
    var camper: SwiftDataCamper

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var viewModel: ViewModel
    @AppSettings(\.settingsSelectedCamperName) var selectedCamperName
    @AppSettings(\.settingsTripFilter) var tripFilter

    @Query(sort: \SwiftDataLogEntry.startDate,
           order: .reverse) var trips: [SwiftDataLogEntry]
    
    @State private var path = [SwiftDataCamper]()
    @State private var editingLogEntry: Bool = false
    @State private var isExporting: Bool = false
    @State var tripToEdit: SwiftDataLogEntry? = nil
    @State private var searchText: String = ""

    init(camper: SwiftDataCamper) {
        self.camper = camper
        // Definition of .predicate is in SwiftDataLogEntry.swift
        let predicate = SwiftDataLogEntry.predicate(searchText: searchText,
                                                    datesToShow: tripFilter,
                                                    camperName: selectedCamperName)
        _trips = Query(filter: predicate, sort: \SwiftDataLogEntry.startDate, order: .reverse)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                NavigationStack(path: $path) {
                    ForEach(trips) { trip in
                        TripCardView(logEntry: trip)
                    }
                }
            }
            .safeAreaInset(edge: .bottom, content: {
                    LogBookBottomBarView(camper: camper)
            })
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
            }
            .sheet(isPresented: $editingLogEntry, content: {
                EditLogEntryView()
            })
            .navigationTitle("Log Book")
        }
    }    
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        LogBookView(camper: SwiftDataCamper.previewCamperA)
        .environmentObject(ViewModel())
    }
}
