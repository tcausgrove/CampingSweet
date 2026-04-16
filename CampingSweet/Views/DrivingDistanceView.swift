//
//  DrivingDistanceView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 8/7/25.
//

import SwiftUI
import Defaults

struct DrivingDistanceView: View {

    @Binding var distanceString: String
    @Default(.settingsKey) var settings
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        
        HStack {
            Text("Distance (\( getDistanceUnitFromSetting() )): ")
            TextField("Enter value", text: $distanceString)
                .keyboardType(.decimalPad)
               .numbersOnly($distanceString, includeDecimal: true, includeNegative: false, digitAllowedAfterDecimal: 1)
        }
    }
}


#Preview {
    DrivingDistanceView(distanceString: .constant("123.4"))
}
