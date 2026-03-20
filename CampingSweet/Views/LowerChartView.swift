//
//  LowerChartView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 12/30/25.
//

import SwiftUI
import Charts
import SwiftData
import Defaults


struct LowerChartView: View {
    var quantityToPlot: ChartYAxis
    
    @Environment(\.modelContext) private var modelContext

//    @Query(sort: [SortDescriptor(\LogEntry.camper?.id, order: .forward)]) private var trips: [LogEntry]
    @Default(.settingsKey) var settings: Settings
    
    @Query private var trips: [LogEntry]
    @State private var yAxisText: String = ""

    init(quantityToPlot: ChartYAxis) {
        self.quantityToPlot = quantityToPlot
        _trips = Query(sort: [SortDescriptor(\LogEntry.startDate, order: .forward)] )
    }
    
    var body: some View {
        if trips.count == 0 {
            ContentUnavailableView("No campsites logged", systemImage: "exclamationmark.octagon", description: Text("There are no campsites logged. Try adding a new campsite in the log book."))
        } else {
            
        Chart(trips) {
            switch quantityToPlot {
                case .distance:
                BarMark(
                    x: .value("Year", $0.startDate.formatted(Date.FormatStyle().year(.defaultDigits))),
                    y: .value("Distance", $0.distanceMeasurement?.converted(to: settings.chosenDistance.unit).value ?? 0.0)
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
            Text(getYAxisLabel(quantityToPlot)) // Units added here!
        }
        .aspectRatio(contentMode: .fit)
        .padding(12)
        }

        Spacer()
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        LowerChartView(quantityToPlot: .distance)
    }
}

func getYAxisLabel(_ quantity: ChartYAxis) -> String {
    switch quantity {
    case .distance:
        let unitText = getDistanceUnitFromSetting()
        return "Distance (\(unitText))"
    case .nights:
        return "Nights"
    }
}
