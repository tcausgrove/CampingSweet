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
                    .padding(.bottom, 30)
                    .font(.title)
                
                TextField("Destination", text: $title)
                    .padding([.leading, .trailing], 16)
                    .padding(.bottom, 30)
                
                DatePicker("Arrival date", selection: $start, displayedComponents: [.date])
                    .onChange(of: start, perform: { _ in
                        numberOfNightsText = setDisplayedNightsText() })
                    .padding([.leading, .trailing], 16)
                
                DatePicker("Departure date", selection: $end, in: start..., displayedComponents: [.date])
                    .onChange(of: end, perform: { _ in
                        numberOfNightsText = setDisplayedNightsText() })
                    .padding([.leading, .trailing], 16)
                
                Text(numberOfNightsText)
                
                //FIXME: Can move this to a function elsewhere, use localized distance, and maybe get long name
                let formatter = MeasurementFormatter()
                let localLength = Measurement<UnitLength>(value: 100.0, unit: UnitLength.kilometers)
                let unit = "Distance (" + viewModel.getDistanceUnitFromSetting() + ")"
                
                TextField(unit, text: $distance)
                    .keyboardType(.decimalPad)
                    .numbersOnly($distance, includeDecimal: true)  // See NumbersOnlyViewModifier.swift
                    .padding([.leading, .trailing], 16)
                
                    .toolbar() {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel", role: .cancel, action: { dismiss() })
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add", role: .none, action: {
                                viewModel.addTrip(title: title, startDate: start, endDate: end, distance: distance)
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
        let numberOfNigts = Int( ((end - start) / 24 / 3600).rounded() )
        return ("Number of nights: \(numberOfNigts)")
    }
}

struct AddLogBookEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogBookEntryView()
            .environmentObject(ViewModel())
    }
}

