//
//  CamperCardView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/1/24.
//

import SwiftUI


struct CamperCardView: View {
    var camper: Camper
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Name: \(camper.name)")
                    .padding()
                if camper.isDefaultCamper {
                    Text("Selected")
                        .italic()
                        .font(.callout)
                }
            }
            Text("Registration: \(camper.registrationNumber)")
        }
        .padding()
    }
}

#Preview {
    CamperCardView(camper: Camper.example)
}
