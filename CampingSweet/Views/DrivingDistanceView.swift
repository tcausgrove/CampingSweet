//
//  DrivingDistanceView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 8/7/25.
//

import SwiftUI

struct DrivingDistanceView: View {
    @EnvironmentObject var viewModel: ViewModel

    @Binding var distanceString: String
//    @FocusState private var focused: Bool
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        
        HStack {
            Text("Distance (\( viewModel.getDistanceUnitFromSetting() )): ")
            TextField("Enter value", text: $distanceString)
//                .onAppear(perform: { focused = true })
//                .focused($focused)
                .keyboardType(.decimalPad)
               .numbersOnly($distanceString, includeDecimal: true, includeNegative: false, digitAllowedAfterDecimal: 1)
        }
//        .toolbar {
//            ToolbarItem(placement: .keyboard) {
//                Spacer()
//            }
//            ToolbarItem(placement: .keyboard) {
//                Button() {
//                    focused = false
//                } label: {
//                    Image(systemName: "keyboard.chevron.compact.down")
//                }
//            }
//        }
    }
}


#Preview {
//    let distance: Measurement<UnitLength> = Measurement(value: 0, unit: .miles)
    DrivingDistanceView(distanceString: .constant("100.0"))
//    DrivingDistanceView()
        .environmentObject(ViewModel())
}
