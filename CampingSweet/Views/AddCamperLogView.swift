//
//  AddVesselLogView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import SwiftUI

struct AddCamperLogView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var registration: String = ""
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add a camper")
                    .padding()
                    .font(.title)
                TextField("Name", text: $name)
                    .padding()
                TextField("Registration", text: $registration)
            }
            .toolbar() {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", role: .none, action: {
                        let newCamper = Camper(id: UUID(), name: name, isDefaultCamper: true, registrationNumber: registration, trips: [])
                        viewModel.addNewCamper(newCamper: newCamper)
                        dismiss()
                    })
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: { dismiss() })
                }
        }
            .padding()
        }
    }
}

struct AddCamperLogView_Previews: PreviewProvider {
    static var previews: some View {
        AddCamperLogView()
            .environmentObject(ViewModel())
    }
}
