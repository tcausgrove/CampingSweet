//
//  DrivingDistanceView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 8/7/25.
//

import SwiftUI

struct DrivingDistanceView: View {
    @EnvironmentObject var viewModel: ViewModel
//    @Binding var distance: Measurement<UnitLength>
//    @State private var distanceString: String = ""
    @Binding var distanceString: String
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        
        HStack {
            Text("Distance (\( viewModel.getDistanceUnitFromSetting() )): ")
            TextField("Enter value", text: $distanceString)
               .keyboardType(.decimalPad)
               .numbersOnly($distanceString, includeDecimal: true, includeNegative: false, digitAllowedAfterDecimal: 1)
//               .onSubmit {
//                   distance = Measurement(value: Double(distanceString) ?? 0.0, unit: viewModel.settings.chosenDistance.unit)
//                }
        }
    }
}


#Preview {
//    let distance: Measurement<UnitLength> = Measurement(value: 0, unit: .miles)
    DrivingDistanceView(distanceString: .constant("100.0"))
//    DrivingDistanceView()
        .environmentObject(ViewModel())
}
