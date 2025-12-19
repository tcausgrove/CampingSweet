//
//  MapsView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 12/17/25.
//

import SwiftUI
import SwiftData
import Defaults


struct MapsView: View {
    
    @Default(.selectedCamperIDKey) var selectedCamperID
    @Environment(\.modelContext) private var modelContext
    @State var yearToMap: String
    @State var years: [String] = []
    
    var body: some View {
        VStack {
            Picker("Make a selection", selection: $yearToMap) {
                ForEach(years, id: \.self) { selection in
                    Text(selection)
                        .tag(selection)
                }
            }
            .padding(12)
            
            Text("Trip list")
                .font(.title.bold())
                .padding(10)
            LowerMapView(yearSelection: yearToMap)
        }
        .onAppear(perform: {
            let camper = Camper.selectedCamperFromID(with: modelContext, selectedCamperID: selectedCamperID)
            years = camper?.yearsUsed ?? ["Not available"]
        })
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        MapsView(yearToMap: "2023")
    }
}
