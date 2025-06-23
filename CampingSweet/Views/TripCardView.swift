//
//  TripCardView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/9/25.
//

import SwiftUI


struct TripCardView: View {
    var trip: SwiftDataLogEntry
    
//    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.modelContext) var modelContext
    @State private var showModMenu = false
    
    var body: some View {
        CardView(backgroundColor: Color.sheetButtonBackground) {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("Title:  \(trip.title)")
                    Spacer()
                    Menu {
                        Button(role: .destructive, action: { deleteTrip(trip: trip) }) {
                            Text("Delete trip")
                        }
                        Button(action: {  }) {
                            Text("Edit trip")
                        }
                    } label: {
                        Text("Trip options")
                    }
                }
                Text("When:  \(trip.startDate.formatted(date: .long, time: .omitted))")
                let numberOfNightsText = "Number of nights:  " + String(trip.numberOfNights)
                Text(numberOfNightsText)
                let tripDistance = trip.distance?.formatted() ?? "0.0 mi"
                HStack {
                    Text("Distance:  " + tripDistance )
                    Spacer()
                }
            }
        }
    }
    
    func deleteTrip(trip: SwiftDataLogEntry) {
        let camper = SwiftDataCamper.selectedCamper(with: modelContext)
        guard let index = camper.trips.firstIndex(of: trip) else { return }
        camper.trips.remove(at: index)
    }
}

#Preview {
    TripCardView(trip: SwiftDataLogEntry(title: "Preview trip", distance: 666.0))
//        .environmentObject(ViewModel())
}
