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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.trips) { trip in
                    VStack(alignment: .leading) {
                        Text("Title: \(trip.title)")
                        Text("When: \(trip.startDate.formatted())")
                        let tripDurationText = "Duration: " + (trip.duration.customTimeFormat(using: [. day, .hour, .minute]) ?? "not available")
                        Text(tripDurationText)
                        let numberOfNightsText = "Number of nights: " + String(trip.numberOfNights)
                        Text(numberOfNightsText)
                        let tripDistance = String(trip.distance ?? 0.0)
                        Text("Distance: \(tripDistance)")
                    }
                    .padding()
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

struct LogBookView_Previews: PreviewProvider {
    static var previews: some View {
        LogBookView()
            .environmentObject(ViewModel())
    }
}
