//
//  AddLogBookEntryView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/12/23.
//

import SwiftUI

struct AddLogBookEntryView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var start: Date = Date()
    @State private var end: Date = Date()
    @State private var distance: String = ""
    
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            VStack {
                Text("new log boook entry")
                    .padding()
                    .font(.title)
                TextField("Title", text: $title)
                    .padding()
                DatePicker("Start", selection: $start)
                DatePicker("End", selection: $end)
                TextField("Distance (miles)", text: $distance)
                    .keyboardType(.decimalPad)
                    .onSubmit {
                        //change string to float and store it
                    }
            }
            .toolbar() {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: { dismiss() })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", role: .none, action: {
                        let tripID = UUID()
                        let newTrip = LogEntry(id: tripID, title: title, startDate: start, endDate: end)
                        viewModel.addTrip(newTrip: newTrip)
                        dismiss()
                    })
                }
        }
            .padding()
        }
    }
}

struct AddLogBookEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogBookEntryView()
    }
}
