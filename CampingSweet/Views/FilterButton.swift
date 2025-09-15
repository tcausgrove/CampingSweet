//
//  FilterButton.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 9/11/25.
//

import SwiftUI

struct FilterButton: View {
    @AppSettings(\.settingsTripFilter) var tripFilter

    var body: some View {
        Menu {
            Picker("", selection: $tripFilter) {
                ForEach(FilterTrips.allCases, id: \.self) { filter in
                    Text(filter.rawValue)
                }
            }
        } label: {
            Label("Show", systemImage: "slider.horizontal.3")
        }
        .pickerStyle(.inline)
    }
}

#Preview {
    FilterButton()
}
