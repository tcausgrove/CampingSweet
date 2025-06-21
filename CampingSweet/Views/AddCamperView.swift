//
//  AddCamperView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import SwiftUI
import SwiftData

struct AddCamperView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var registration: String = ""
    
//    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
//            Text("Add a camper", tableName: "Localizable")
//                .padding()
//                .font(.title2)

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
                    Spacer()
                    Button("Cancel", role: .cancel, action: { dismiss() })
                }
            }
            .padding()
        }
//        .navigationTitle("Add a camper")
    
    func addNewCamper() {
        let newCamper = SwiftDataCamper(name: name, isDefaultCamper: true, isArchived: false, registrationNumber: registration)
        modelContext.insert(newCamper)
//        viewModel.addNewCamper(newCamper: newCamper)
        dismiss()
    }
}

#Preview {
    AddCamperView()
}
//struct AddCamperLogView_Previews: PreviewProvider {
///    static var previews: some View {
//        AddCamperView()
//            .environmentObject(ViewModel())
//    }
//}
