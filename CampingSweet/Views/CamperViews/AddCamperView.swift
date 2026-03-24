//
//  AddCamperView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import SwiftUI
import SwiftData
import Defaults

struct AddCamperView: View {
    @Environment(\.modelContext) var modelContext
//    @Default(.selectedCamperIDKey) var selectedCamperID
    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var registration: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField(text: $name, prompt: Text("Name", tableName: "Localizable")) { }
                    .padding()
                TextField("Registration", text: $registration)
                    .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom]/*@END_MENU_TOKEN@*/)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    Button("Add", role: .none, action: {
                        addNewCamper()
                    })
                    .disabled(name.isEmpty)
                    Spacer()
                    Button("Cancel", role: .cancel, action: { dismiss() })
                }
            }
            .padding()
            .navigationTitle("Add a camper")
        }
    }
    
    func addNewCamper() {
        let newCamper = Camper(id: UUID(), name: name, isArchived: false, registrationNumber: registration)
        modelContext.insert(newCamper)
//        selectedCamperID = newCamper.id
        
        dismiss()
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        AddCamperView()
    }
}
