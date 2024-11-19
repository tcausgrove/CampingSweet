//
//  EditLogEntryView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 11/18/24.
//

import SwiftUI

struct EditLogEntryView: View {
    
    @Binding var previousLogEntry: LogEntry?
        
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var start: Date = Date()
    @State private var end: Date = Date()
    @State private var distance: String = ""
    
    var body: some View {
        NavigationView {
             VStack {
                 Text( "Edit Log Book Entry" )
                     .padding(.bottom, 30)
                     .font(.title)
                 
                TripDataEntryView(title: $title, start: $start, end: $end, distance: $distance)
            }
            .padding()
            .toolbar() {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: { dismiss() })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save Changes", role: .none, action: {
                        let theTripID = previousLogEntry?.id ?? UUID()
                        viewModel.editTrip(tripID: theTripID, title: title, startDate: start, endDate: end, distance: distance)
                        dismiss()
                    })
                }
            }
            .onAppear(perform: { populateVariables() })
        }
    }
    
    func populateVariables() {
        if previousLogEntry == nil { // This really shouldn't happen
            previousLogEntry = LogEntry.example
        } else {
            title = previousLogEntry!.title
            start = previousLogEntry!.startDate
            end = previousLogEntry!.endDate
            let newDistance: Double =  previousLogEntry!.distance!
            distance = String(newDistance)
        }
    }
}

#Preview {
    EditLogEntryView(previousLogEntry: .constant(LogEntry.example))
        .environmentObject(ViewModel())
}
