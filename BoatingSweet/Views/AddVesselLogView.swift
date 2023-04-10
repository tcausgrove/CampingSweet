//
//  AddVesselLogView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import SwiftUI

struct AddVesselLogView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var registration: String = ""
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add a Boat")
                    .padding()
                    .font(.title)
                TextField("Name", text: $name)
                    .padding()
                TextField("Registration", text: $registration)
            }
            .toolbar() {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: { dismiss() })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", role: .none, action: {
                        let newBoat = Boat(id: UUID(), name: name, registrationNumber: registration)
                        viewModel.addNewVessel(newVessel: newBoat)
                        dismiss()
                    })
                }
        }
            .padding()
        }    }
}

struct AddVesselLogView_Previews: PreviewProvider {
    static var previews: some View {
        AddVesselLogView()
    }
}
