//
//  AddLogBookEntryView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/12/23.
//

import SwiftUI

struct AddLogBookEntryView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var start: Date = Date()
    @State private var end: Date = Date()
    @State private var distance: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text( "New Log Book Entry" )
                    .padding(.bottom, 12)
                    .font(.title2)
                
                TripDataEntryView(title: $title,
                                  start: $start,
                                  end: $end,
                                  distance: $distance,
                                  latitude: $latitude,
                                  longitude: $longitude)
            }
            .padding()
            .toolbar() {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: { dismiss() })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", role: .none, action: {
                        viewModel.addTrip(title: title, startDate: start, endDate: end, distance: distance, latitude: latitude, longitude: longitude)
                        dismiss()
                    })
                }
            }
        }
    }
}

struct AddLogBookEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogBookEntryView()
            .environmentObject(ViewModel())
    }
}

