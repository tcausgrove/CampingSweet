//
//  TripDataEntryView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 11/18/24.
//

import SwiftUI

struct TripDataEntryView: View {
    
    @EnvironmentObject var viewModel: ViewModel

    @Binding var title: String
    @Binding var start: Date
    @Binding var end: Date
    @Binding var distance: String
    
    @State private var numberOfNightsText: String = " "

    var body: some View {
        Form {
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
                .padding([.leading, .trailing], 16)

            let unit = "Distance (" + viewModel.getDistanceUnitFromSetting() + ")"
            
            TextField(unit, text: $distance)
                .keyboardType(.decimalPad)
                .numbersOnly($distance, includeDecimal: true)  // See NumbersOnlyViewModifier.swift
                .padding([.leading, .trailing], 16)
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

#Preview {
    TripDataEntryView(title: .constant("Nowhere special"),
                      start: .constant(Date.now),
                      end: .constant(Date.now),
                      distance: .constant("123.4"))
}
