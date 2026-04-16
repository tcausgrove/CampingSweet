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
    
    @State private var searchText: String = ""
    @State private var refreshView: Bool = false
    @Default(.settingsKey) var settings
    
    @Default(.selectedCamperIDKey) var selectedCamperID
    
    @Query(sort: \LogEntry.startDate,
           order: .reverse) private var trips: [LogEntry]
    
    init(yearSelection: String, camperName: String) {
        let yearPredicate = LogEntry.yearSelectPredicate(yearSelection: yearSelection)
        _trips = Query(filter: yearPredicate, sort: \LogEntry.startDate, order: .reverse)
    }

    var body: some View {
        ScrollView {
            ForEach(trips, id: \.id) { trip in
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
        LowerLogBookView(yearSelection: "All years", camperName: Camper.previewCamperA.name)
    }
}
