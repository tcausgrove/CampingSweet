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
        VStack {
            ForEach(viewModel.campers) { camper in
                Section {
                    CamperCardView(camper: camper)
                        .environmentObject(viewModel)
                        .onTapGesture {
                            viewModel.setCurrentCamper(selectedCamperName: camper.name)
                        }
                }
            }
            Spacer()
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
        .navigationTitle("Campers")
    }
}

struct CamperLogView_Previews: PreviewProvider {
    static var previews: some View {
        CamperLogView()
            .environmentObject(ViewModel())
    }
}
