//
//  FuelLogView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI

struct FuelLogView: View {
    @EnvironmentObject var viewModel: ViewModel    
    @State private var addingFuelEntry: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(viewModel.fuelings) { fueling in
                    VStack(alignment: .leading) {
                        Text("Date: \(fueling.date.formatted())")
                        Text("Gallons: \(String(fueling.volume))")
                        Text("Cost: \(String(fueling.cost))")
                    }
                    .padding()
                }
            }
            .toolbar() {
                ToolbarItem {
                    Button(action: { addingFuelEntry.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $addingFuelEntry, content: {
                let currentBoat = viewModel.getCurrentBoat() ?? Boat(id: UUID(), name: "foo", registrationNumber: "Temp")
                AddFuelLogEntryView(boat: currentBoat )
            })
            .navigationTitle("Fuel Log")
        }
    }
}

//struct FuelLogView_Previews: PreviewProvider {
//    static var previews: some View {
//        FuelLogView()
//    }
//}
