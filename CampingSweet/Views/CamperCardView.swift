//
//  CamperCardView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/1/24.
//

import SwiftUI
import SwiftData

struct CamperCardView: View {
    @Bindable var camper: SwiftDataCamper
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var viewModel: ViewModel

    @State private var showModMenu = false

    var body: some View {
        CardView(backgroundColor: Color.sheetButtonBackground) {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Spacer()
                    Image(systemName: "ellipsis")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .onTapGesture(perform: { showModMenu = true })
                        .padding(.trailing, 12)
                }
                .sheet(isPresented: $showModMenu, content: { sheetContents })
                HStack {
                    Text("Name: \(camper.name)")
                    if camper.isDefaultCamperBool {
                        Text("Selected")
                            .italic()
                            .font(.callout)
                    }
                }
                
                Text("Registration: \(camper.registrationNumber)")
                
                if camper.totalCamperDistance > 0.1 {
                    let tripDistanceString = viewModel.formatDistanceBySetting(distance: camper.totalCamperDistance)
                    Text("Distance traveled" + ": " + tripDistanceString)
                }
                Text("Number of nights used: \(camper.totalCamperNights)")
            }
        }
    }
    
    @ViewBuilder var sheetContents: some View {
        let menuHeaderText = "Options for camper " + camper.name
        Text(menuHeaderText)
            .font(.title3)
        VStack(alignment: .center, spacing: 16) {
            Button(role: .destructive, action: {
                // FIXME:  Before deleting, check to see if this is default camper;
                //  if so, look for another for default. If no others, then create a camper
                deleteCamper(camper: camper)
            }) {
                Text("Delete camper")
            }
            .sheetButtonStyle()

            Button(action: {
                camper.isArchived = true
                camper.isDefaultCamperBool = false
                showModMenu = false
            }) {
                Text("Archive camper")
            }
            .sheetButtonStyle()

            Button(action: { showModMenu = false }) {
                Text("Cancel")
            }
            .sheetButtonStyle()
        }
        .padding([.leading, .trailing], 20)
        .frame(minWidth: 320)
        .presentationDetents([.fraction(0.35)])
        .presentationDragIndicator(.hidden)
    }
    
    func deleteCamper(camper: SwiftDataCamper) {
        if camper.isDefaultCamperBool {
            // set a new default
            if let topCamper = try! modelContext.fetch(FetchDescriptor<SwiftDataCamper>()).first {
                topCamper.isDefaultCamperBool = true
            }
        }
        modelContext.delete(camper)
        showModMenu = false
    }
}

#Preview {
    let previewTrips =
    [SwiftDataLogEntry(title: "Trip 1", distance: 123, startDate: Date(), endDate: Date()),
     SwiftDataLogEntry(title: "Trip 2", distance: 234, startDate: Date(), endDate: Date())]
    CamperCardView(camper: SwiftDataCamper(name: "Preview camper", isDefaultCamper: 0, isArchived: false, registrationNumber: "Anything", trips: previewTrips))
        .environmentObject(ViewModel())
}
