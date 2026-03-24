//
//  CamperCardView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/1/24.
//

import SwiftUI
import SwiftData
import Defaults

struct CamperCardView: View {
    var camper: Camper

    @Environment(\.modelContext) var modelContext
    @Default(.settingsKey) var settings
//    @Default(.selectedCamperIDKey) var selectedCamperID

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
                    if camper.id == selectedCamperID {
                        Text("Selected")
                            .italic()
                            .foregroundColor(.red)
//                            .font(.callout)
                    }
                }
                
                Text("Registration: \(camper.registrationNumber)")
                
                if camper.totalCamperDistance > 0.1 {
                    let tripDistanceString = formatDistanceBySetting(distance: camper.totalCamperDistance)
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
                deleteCamper(camper: camper)
            }) {
                Text("Delete camper")
            }
            .sheetButtonStyle()

            /// I took this out because there isn't much advantage to archiving, and it makes the logic of deleting a camper
            /// more convoluted.  If the last unarchived camper is deleted, should an unarchived camper be the selected camper?
            ///  Also, should unarchived be included in charts and maps?  Archiving just overall adds too much complication.
//            Button(action: {
//                camper.isArchived = true
//                if camper.id == selectedCamperID {
//                    selectedCamperID = nil
//                }
//                showModMenu = false
//            }) {
//                Text("Archive camper")
//            }
//            .sheetButtonStyle()

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
    
    func deleteCamper(camper: Camper) {
        if camper.id == selectedCamperID {
            // set the first camper that is not selected as the new selected
            if let topCamper = try! modelContext.fetch(FetchDescriptor<Camper>()).first(where: { $0.id != selectedCamperID }) {
                selectedCamperID = topCamper.id
            } else {
                // There is no camper to set as default
                selectedCamperID = nil
            }
        }
        modelContext.delete(camper)
        showModMenu = false
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        CamperCardView(camper: Camper.previewCamperA)
    }

}
