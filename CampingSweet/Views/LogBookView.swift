//
//  LogBookView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI

struct LogBookView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var addingLogEntry = false
    @State private var checkForDelete = false

    var body: some View {
        NavigationView {
            VStack {
                Text("For camper \(viewModel.getCurrentCamperName())")
                    .font(.title2)
//                Text("Total miles: \( viewModel.getTotalCurrentCamperMiles() )")
                List {
                    let camper = viewModel.getCurrentCamper()
                    if camper != nil {
                        ForEach(camper!.trips) { trip in
                            TripCardView(trip: trip)
                                .environmentObject(viewModel)
                        }
                        .onDelete { indexSet in
                            viewModel.deleteTrips(indexSet: indexSet)
                        }
                    }
                }
                .toolbar() {
                    ToolbarItem {
                        Button(action: { addingLogEntry.toggle()}) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $addingLogEntry, content: {
                    AddLogBookEntryView()
                        .environmentObject(viewModel)
                })
            .navigationTitle("Log Book")
            }
        }

    }
}

struct LogBookView_Previews: PreviewProvider {
    static var previews: some View {
        LogBookView()
            .environmentObject(ViewModel())
    }
}

struct TripCardView: View {
    var trip: LogEntry
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        if trip.camperID == viewModel.getCurrentCamperID() {
            VStack(alignment: .leading) {
                Text("Title:  \(trip.title)")
                Text("When:  \(trip.startDate.formatted())")
                let numberOfNightsText = "Number of nights:  " + String(trip.numberOfNights)
                Text(numberOfNightsText)
                let tripDistance = String(trip.distance ?? 0.0)
                Text("Distance:  \(tripDistance)")
            }
            .padding()
        }
    }
}
