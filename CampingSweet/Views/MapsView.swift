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
    @State var camperName: String = ""
    
    var body: some View {
        VStack {
            LowerMapView(yearSelection: yearToMap, camperName: camperName)
        }
        .onAppear(perform: { // Get the list of years to be listed in the picker
            let camper = Camper.selectedCamperFromID(with: modelContext, selectedCamperID: selectedCamperID)
            years = camper?.yearsUsed ?? ["Not available"]
            camperName = camper?.name ?? "Not available"
        })
        .toolbar() {
            ToolbarItem(placement: .automatic) {
                Menu {
                    Picker("", selection: $yearToMap) {
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
            ToolbarItem(placement: .principal, content: { Text(camperName)})
        }
        .navigationTitle("Maps")
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        MapsView(yearToMap: "All years")
    }
}
