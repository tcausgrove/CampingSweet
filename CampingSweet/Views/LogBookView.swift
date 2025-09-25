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

    @Query(sort: \SwiftDataLogEntry.startDate,
           order: .reverse) private var trips: [SwiftDataLogEntry]
    
//    @State private var path = [SwiftDataCamper]()
    @State private var editingLogEntry: Bool = false
    @State private var isExporting: Bool = false
    @State var tripToEdit: SwiftDataLogEntry? = nil
    @State private var searchText: String = ""
    
    init(localCamperID: UUID, tripFilter: FilterTrips) {
        self.localCamperID = localCamperID
        self.tripFilter = tripFilter
        
        let predicate = SwiftDataLogEntry.predicate(searchText: searchText,
                                                        datesToShow: tripFilter,
                                                        camperID: localCamperID)
        _trips = Query(filter: predicate, sort: \SwiftDataLogEntry.startDate, order: .reverse)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
//                NavigationStack(path: $path) {
                    ForEach(trips) { trip in
                        TripCardView(logEntry: trip)
                    }
//                }
            }
            .safeAreaInset(edge: .bottom, content: {
                let camper = SwiftDataCamper.selectedCamperFromID(with: modelContext, selectedCamperID: localCamperID)
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
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        LogBookView(localCamperID: SwiftDataCamper.previewCamperA.id, tripFilter: .allTrips)
    }
}
