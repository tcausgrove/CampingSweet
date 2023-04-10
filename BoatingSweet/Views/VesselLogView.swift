//
//  VesselLogView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import SwiftUI

struct VesselLogView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var addingVessel: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.boats) { boat in
                    VStack(alignment: .leading) {
                        Text("Name: \(boat.name)")
                        Text("Registration: \(boat.registrationNumber)")
                    }
                    .padding()
                }
            }
            .toolbar() {
                ToolbarItem {
                    Button(action: { addingVessel.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $addingVessel) {
                AddVesselLogView()
            }
            .navigationTitle("Vessel Log")
        }
    }
}

//struct VesselLogView_Previews: PreviewProvider {
//    static var previews: some View {
//        VesselLogView()
//    }
//}
