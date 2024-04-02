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
    @State private var numberOfNightsText: String = " "
    @State private var distance: String = ""
    @FocusState private var distanceIsFocused: Bool
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("New Log Book Entry")
                    .padding()
                    .font(.title)
                TextField("Title", text: $title)
                    .padding()
                DatePicker("Arrival date", selection: $start, displayedComponents: [.date])
                    .onChange(of: start, perform: { _ in
                        numberOfNightsText = setDisplayedNightsText() })
                DatePicker("Departure date", selection: $end, in: start..., displayedComponents: [.date])
                    .onChange(of: end, perform: { _ in
                        numberOfNightsText = setDisplayedNightsText() })
                Text(numberOfNightsText)
                TextField("Distance (miles)", text: $distance)
                    .keyboardType(.decimalPad)
                    .numbersOnly($distance, includeDecimal: true)  // See NumbersOnlyViewModifier.swift
                
                    .toolbar() {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel", role: .cancel, action: { dismiss() })
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add", role: .none, action: {
                                let tripID = UUID()
                                if let camperID = viewModel.getCurrentCamperID() {
                                    let newTrip = LogEntry(id: tripID, camperID: camperID, title: title, startDate: start, endDate: end, distance: Float(distance))
                                    viewModel.addTrip(newTrip: newTrip)

                                }
                                dismiss()
                            })
                        }
                    }
            }
            .padding()
        }
    }
    
    // FIXME:  This should go in the viewmodel, there is already something there
    func setDisplayedNightsText() -> String {
        if (end < start) {
            end = start
        }
        let numberOfNigts = ((end - start) / 24 / 3600).formatted()
        return ("Number of nights: " + numberOfNigts)
    }
}

struct AddLogBookEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogBookEntryView()
    }
}

