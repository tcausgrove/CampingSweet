//
//  LowerLogBookView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 1/18/26.
//

import SwiftUI
import SwiftData
import Defaults

struct LowerLogBookView: View {
    var camper: Camper
    var tripFilter: FilterTrips
    
    @State private var searchText: String = ""
    @Default(.settingsKey) var settings
    
    @Query(sort: \LogEntry.startDate,
           order: .reverse) private var trips: [LogEntry]
    
    init(camper: Camper, tripFilter: FilterTrips) {
        self.camper = camper
        self.tripFilter = tripFilter
        
        let predicate = LogEntry.logBookPredicate(searchText: searchText,
                                           datesToShow: tripFilter,
                                                  camperID: camper.id)
        _trips = Query(filter: predicate, sort: \LogEntry.startDate, order: .reverse)
    }
    
    var body: some View {
        ScrollView {
//                    if settings.chosentripFormat == .list {
//                        Divider()   // An extra divider at the top of the list
//                    }
            ForEach(trips) { trip in
                switch settings.chosentripFormat {
                case .card:
                    TripCardView(logEntry: trip)
                case .list:
                    TripListView(logEntry: trip)
                        .padding([.leading, .trailing], 10)
                }
            }
        }
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var modelContext
    ModelContainerPreview(ModelContainer.sample) {
        let camper: Camper = try! modelContext.fetch(FetchDescriptor<Camper>()).first!
        LowerLogBookView(camper: camper, tripFilter: .allTrips)
    }
}
