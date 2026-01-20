//
//  ChartsView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 12/25/25.
//

import SwiftUI
import SwiftData
import Defaults

struct ChartsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Default(.quantityToPlot) var quantityToPlot

    var body: some View {
        VStack {
            LowerChartView(quantityToPlot: quantityToPlot)
                .background()
                .padding(.top, 20)
            
            Spacer()
        }
        .toolbar {
            Menu {
                Picker("", selection: $quantityToPlot) {
                    ForEach(ChartYAxis.allCases, id: \.self) { selection in
                        Text(selection.rawValue)
                            .tag(selection)
                    }
                }
            } label: {
                Label("\(quantityToPlot.rawValue)", systemImage: "slider.horizontal.3")
            }
            .pickerStyle(.inline)
         }
        .background(BackgroundView()).scrollContentBackground(.hidden)
        .navigationTitle("Charts")
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        ChartsView()
    }
}

