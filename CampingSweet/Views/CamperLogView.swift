//
//  CamperLogView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import SwiftUI

struct CamperLogView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var addingCamper: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.campers) { camper in
                    VStack(alignment: .leading) {
                        Text("Name: \(camper.name)")
                        Text("Registration: \(camper.registrationNumber)")
                    }
                    .padding()
                }
            }
            .toolbar() {
                ToolbarItem {
                    Button(action: { addingCamper.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $addingCamper) {
                AddCamperLogView()
                    .environmentObject(viewModel)
            }
            .navigationTitle("Camper Log")
        }
    }
}

struct CamperLogView_Previews: PreviewProvider {
    static var previews: some View {
        CamperLogView()
            .environmentObject(ViewModel())
    }
}
