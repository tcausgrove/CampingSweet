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
    ModelContainerPreview(ModelContainer.sample) {
        LowerLogBookView(camperID: Camper.previewCamperA.id, tripFilter: .allTrips)
    }
}
