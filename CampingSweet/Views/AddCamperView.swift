//
//  AddCamperView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import SwiftUI

struct AddCamperView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var registration: String = ""
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Text("Add a camper", tableName: "Localizable")
                    .padding()
                    .font(.title2)
                TextField(text: $name, prompt: Text("Name", tableName: "Localizable")) { }
                    .padding()
                TextField("Registration", text: $registration)
                    .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom]/*@END_MENU_TOKEN@*/)
            }
            .toolbar() {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", role: .none, action: {
                        addNewCamper()
                    })
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: { dismiss() })
                }
            }
            .padding()
        }
    }
    
    func addNewCamper() {
        let newCamper = Camper(id: UUID(), name: name, isDefaultCamper: true, isArchived: false, registrationNumber: registration, trips: [])
        viewModel.addNewCamper(newCamper: newCamper)
        dismiss()
    }
}

struct AddCamperLogView_Previews: PreviewProvider {
    static var previews: some View {
        AddCamperView()
            .environmentObject(ViewModel())
    }
}
