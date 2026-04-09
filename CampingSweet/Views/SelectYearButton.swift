//
//  SelectYearButton.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 3/25/26.
//

import SwiftUI

struct SelectYearButton: View {
    var years: [String]
    @Binding var yearToShow: String
    
    var body: some View {
        Menu {
            Picker("", selection: $yearToShow) {
                ForEach(years, id: \.self) { selection in
                    Text(selection)
                        .tag(selection)
                }
            }
        } label: {
            Label("Show", systemImage: "slider.horizontal.3")
        }
        .pickerStyle(.inline)
    }
}

#Preview {
    let years: [String] = ["All years"]
    SelectYearButton(years: years, yearToShow: .constant("All years"))
}
