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
    @Default(.quantityToPlotKey) var quantityToPlot

    var body: some View {
        VStack {
            HStack {
                Spacer()
                
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
                .padding(.trailing, 30)
                .pickerStyle(.inline)
            }
            
            LowerChartView(quantityToPlot: quantityToPlot)
                .background()
                .padding(.top, 20)
            
            Spacer()
        }
        .toolbar {
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

