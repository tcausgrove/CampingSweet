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
    var localCamper: SwiftDataCamper
    var tripFilter: FilterTrips

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var viewModel: ViewModel
//    @Default(.tripFilterKey) var tripFilter

    @Query(sort: \SwiftDataLogEntry.startDate,
           order: .reverse) var trips: [SwiftDataLogEntry]
    
    @State private var path = [SwiftDataCamper]()
    @State private var editingLogEntry: Bool = false
    @State private var isExporting: Bool = false
    @State var tripToEdit: SwiftDataLogEntry? = nil
    @State private var searchText: String = ""

    init(camper: SwiftDataCamper, tripFilter: FilterTrips) {
        self.localCamper = camper
        self.tripFilter = tripFilter
//        self.selectedID = selectedID
        // Definition of .predicate is in SwiftDataLogEntry.swift
//        if camper == nil {
//            _trips = Query(sort: \SwiftDataLogEntry.startDate, order: .reverse)
//        } else {
            let predicate = SwiftDataLogEntry.predicate(searchText: searchText,
                                                        datesToShow: tripFilter,
                                                        camperID: localCamper.id)
            _trips = Query(filter: predicate, sort: \SwiftDataLogEntry.startDate, order: .reverse)
//        }
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
                    LogBookBottomBarView(camper: localCamper)
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
        LogBookView(camper: SwiftDataCamper.previewCamperA, tripFilter: .allTrips)
        .environmentObject(ViewModel())
    }
}
