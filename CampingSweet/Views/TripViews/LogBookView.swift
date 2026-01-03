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
    var tripFilter: FilterTrips
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Default(.settingsKey) var settings

    @Query(sort: \LogEntry.startDate,
           order: .reverse) private var trips: [LogEntry]
    
    @State private var editingLogEntry: Bool = false
    @State private var isExporting: Bool = false
    @State var tripToEdit: LogEntry? = nil
    @State private var searchText: String = ""
    
    init(localCamperID: UUID, tripFilter: FilterTrips) {
        self.localCamperID = localCamperID
        self.tripFilter = tripFilter
        
        let predicate = LogEntry.logBookPredicate(searchText: searchText,
                                           datesToShow: tripFilter,
                                           camperID: localCamperID)
        _trips = Query(filter: predicate, sort: \LogEntry.startDate, order: .reverse)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                if settings.chosentripFormat == .list {
                    Divider()
                }
                ForEach(trips) { trip in
                    switch settings.chosentripFormat {
                    case .card:
                        TripCardView(logEntry: trip)
                    case .list:
                        TripListView(logEntry: trip)
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            let camper = Camper.selectedCamperFromID(with: modelContext, selectedCamperID: localCamperID)
            if camper != nil {
                LogBookBottomBarView(camper: camper!)
            }
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

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        LogBookView(localCamperID: Camper.previewCamperA.id, tripFilter: .allTrips)
    }
}
