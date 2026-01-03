//
//  LowerChartView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 12/30/25.
//

import SwiftUI
import Charts
import SwiftData


struct LowerChartView: View {
    var quantityToPlot: ChartYAxis
    
    @Environment(\.modelContext) private var modelContext

//    @Query(sort: [SortDescriptor(\LogEntry.camper?.id, order: .forward)]) private var trips: [LogEntry]
    @Query private var trips: [LogEntry]
    @State private var yAxisText: String = ""

    init(quantityToPlot: ChartYAxis) {
        self.quantityToPlot = quantityToPlot
        _trips = Query(sort: [SortDescriptor(\LogEntry.startDate, order: .forward)] )
    }
    
    var body: some View {
        Chart(trips) {
            switch quantityToPlot {
                case .distance:
                BarMark(
                    x: .value("Year", $0.startDate.formatted(Date.FormatStyle().year(.defaultDigits))),
                    y: .value("Distance", $0.distance ?? 0.0)
                )
                .foregroundStyle(by: .value("Camper", $0.camper?.name ?? "Unknown"))
            case .nights:
                BarMark(
                    x: .value("Year", $0.startDate.formatted(Date.FormatStyle().year(.defaultDigits))),
                    y: .value("Nights", $0.numberOfNights)
                )
                .foregroundStyle(by: .value("Camper", $0.camper?.name ?? "Unknown"))
            }
        }
        .chartYAxisLabel(position: .trailing) {
            Text(yAxisText) // Units added here!
        }
        .onAppear() {
            switch quantityToPlot {
            case .distance:
                yAxisText = "Distance (km)"
            case .nights:
                yAxisText = "Nights"
            }
        }
        .aspectRatio(contentMode: .fit)
        .padding(20)
        
        Spacer()
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        LowerChartView(quantityToPlot: .distance)
    }
}
