//
//  TripCardView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/9/25.
//

import SwiftUI


struct TripCardView: View {
    var trip: SwiftDataLogEntry
    
    @EnvironmentObject var viewModel: ViewModel
    @State private var showModMenu = false
    
    var body: some View {
        CardView(backgroundColor: Color.sheetButtonBackground) {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("Title:  \(trip.title)")
                    Spacer()
                    Image(systemName: "ellipsis")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .onTapGesture(perform: { showModMenu = true })
                        .padding(.trailing, 12)
                }
                .popover(isPresented: $showModMenu,
                         attachmentAnchor: .point(.trailing),
                         content: { popoverContents })
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
    
    @ViewBuilder var popoverContents: some View {
        VStack {
            Button(role: .destructive) {
//                viewModel.deleteTrip(tripID: trip.id)
            } label: {
                Text("Delete trip")
            }
        }
        .padding(12)
        .presentationCompactAdaptation(.popover)
    }
}

#Preview {
    TripCardView(trip: SwiftDataLogEntry(title: "Preview trip", distance: 666.0))
//        .environmentObject(ViewModel())
}
