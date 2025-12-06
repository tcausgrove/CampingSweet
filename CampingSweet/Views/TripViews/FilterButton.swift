//
//  FilterButton.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 9/11/25.
//

import SwiftUI
import Defaults

struct FilterButton: View {
    @Default(.tripFilterKey) var tripFilter: FilterTrips

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
