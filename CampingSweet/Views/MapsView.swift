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
    @State var yearToShow: String
    @State var years: [String] = []
    @State var camperName: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text(camperName)
                
                Spacer()
                
                SelectYearButton(years: years, yearToShow: $yearToShow)
           }
            
            if selectedCamperID == nil {
                ContentUnavailableView("No camper selected", systemImage: "exclamationmark.octagon", description: Text("Please select a camper from the Campers option"))
            } else {
                LowerMapView(yearSelection: yearToShow, camperName: camperName)
            }
        }
        .onAppear(perform: { // Get the list of years to be listed in the picker
            let camper = Camper.selectedCamperFromID(with: modelContext, selectedCamperID: selectedCamperID)
            years = camper?.yearsUsed ?? ["Not available"]
            camperName = camper?.name ?? "Not available"
        })
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        MapsView(yearToShow: "All years")
    }
}
