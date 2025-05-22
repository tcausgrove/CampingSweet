//
//  CamperCardView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/1/24.
//

import SwiftUI


struct CamperCardView: View {
    var camper: Camper
    
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
                    if camper.isDefaultCamper {
                        Text("Selected")
                            .italic()
                            .font(.callout)
                    }
                }
                
                Text("Registration: \(camper.registrationNumber)")
                
                if camper.totalCamperDistance > 0.1 {
                    Text("Distance traveled: \(viewModel.getCamperFormattedDistance(theCamper: camper))")
                }
                Text("Number of nights used: \(camper.totalCamperNights)")
            }
        }
    }
    
    @ViewBuilder var sheetContents: some View {
        let menuHeaderText = "Options for camper " + camper.name  //viewModel.getCurrentCamperName()
        Text(menuHeaderText)
            .font(.title3)
        VStack(alignment: .center, spacing: 16) {
            Button(role: .destructive, action: {
                viewModel.deleteCamper(camperToDelete: camper)
                showModMenu = false
            }) {
                Text("Delete camper")
            }
            .sheetButtonStyle()

            Button(action: {
                viewModel.toggleCamperArchival(camperToArchive: camper)
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
}

#Preview {
    CamperCardView(camper: Camper.example)
        .environmentObject(ViewModel())
}
