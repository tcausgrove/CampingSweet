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
    var camperID: UUID
    var tripFilter: FilterTrips
    
    @State private var searchText: String = ""
    @State private var refreshView: Bool = false
    @Default(.settingsKey) var settings
    
    @Query(sort: \LogEntry.startDate,
           order: .reverse) private var trips: [LogEntry]
    
    init(camperID: UUID, tripFilter: FilterTrips) {
        self.camperID = camperID
        self.tripFilter = tripFilter
        
        let predicate = LogEntry.logBookPredicate(searchText: searchText,
                                                  datesToShow: tripFilter,
                                                  camperID: camperID)
        _trips = Query(filter: predicate, sort: \LogEntry.startDate, order: .reverse)
    }
    
    var body: some View {
        ScrollView {
            ForEach(trips, id: \.self) { trip in
                switch settings.chosentripFormat {
                case .card:
                    TripCardView(logEntry: trip)
                case .list:
                    TripListView(logEntry: trip)
                        .padding([.leading, .trailing], 10)
                }
            }
        }
        /// The following two modifiers are a hack.  I should be able to do better.
        .onAppear {
            refreshView.toggle()
        }
        .id(refreshView)
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        LowerLogBookView(camperID: Camper.previewCamperA.id, tripFilter: .allTrips)
    }
}
