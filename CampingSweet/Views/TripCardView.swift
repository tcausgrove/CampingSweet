//
//  TripCardView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/9/25.
//

import SwiftUI


struct TripCardView: View {
    var trip: LogEntry
    
    @EnvironmentObject var viewModel: ViewModel
    @State private var showModMenu = false
    
    var body: some View {
        CardView(backgroundColor: Color.sheetButtonBackground) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Title:  \(trip.title)")
                Text("When:  \(trip.startDate.formatted(date: .long, time: .omitted))")
                let numberOfNightsText = "Number of nights:  " + String(trip.numberOfNights)
                Text(numberOfNightsText)
                let tripDistance = viewModel.formatDistanceBySetting(distance: trip.distance ?? 0.0)
                HStack {
                    Text("Distance:  " + tripDistance )
                    Spacer()
                }
            }
            .padding(.top, 12)
        }
    }
}

#Preview {
    TripCardView(trip: LogEntry.example)
        .environmentObject(ViewModel())
}
