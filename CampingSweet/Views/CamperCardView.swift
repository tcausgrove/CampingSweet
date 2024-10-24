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
    
    var body: some View {
        VStack(alignment: .leading) {
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

#Preview {
    CamperCardView(camper: Camper.example)
        .environmentObject(ViewModel())
}
