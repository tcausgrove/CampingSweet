//
//  AddFuelLogEntryView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import SwiftUI

struct AddFuelLogEntryView: View {
    @Environment(\.dismiss) var dismiss

    @State var boat: Boat

    @State private var date: Date = Date()
    @State private var engineHours: String = ""
    @State private var cost: String = ""
    @State private var volume: String = ""
    
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            Form {
                Text("New Fuel Log Entry")
                    .padding()
                    .font(.title)
                DatePicker("Date", selection: $date)
                    .padding()
                Picker("Boat", selection: $boat) {
                    ForEach(viewModel.boats, id: \.self) { boat in
                        Text(boat.name)
                    }
                }
                TextField("Engine Hours", text: $engineHours)
                    .keyboardType(.decimalPad)
                    .onSubmit {
                        //change string to float and store it
                    }
                TextField("Cost", text: $cost)
                    .keyboardType(.decimalPad)
                    .onSubmit {
                        //change string to float and store it
                    }
                TextField("Gallons", text: $volume)
                    .keyboardType(.decimalPad)
                    .onSubmit {
                        //change name string to float and store it
                    }
            }
            .toolbar() {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel, action: { dismiss() })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", role: .none, action: {
                        let fuelEntryID = UUID()
                        let newFuelEntry = FuelEntry(
                            id: fuelEntryID,
                            date: date,
                            engineHours: (engineHours as NSString).floatValue,
                            cost: (cost as NSString).floatValue,
                            volume: (volume as NSString).floatValue)
                        viewModel.addFuelEntry(newFuelEntry: newFuelEntry)
                        dismiss()
                    })
                }
        }
            .padding()
        }
    }
}

//struct AddFuelLogEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddFuelLogEntryView()
//    }
//}
