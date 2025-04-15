//
//  CamperLogView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import SwiftUI

struct CampersView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var addingCamper: Bool = false
    
    var body: some View {
        VStack {
            ForEach(viewModel.campers) { camper in
                if !camper.isArchived {
                    CamperCardView(camper: camper)
                        .padding(.bottom, 8)
                        .environmentObject(viewModel)
                        .onTapGesture {
                            viewModel.setCurrentCamper(selectedCamperName: camper.name)
                        }
                }
            }
            
            Spacer()

            
            if viewModel.hasArchivedCampers() {
                Text("Archived campers")
                    .font(.title2)
                    .bold()
            }
            ForEach(viewModel.campers) { camper in
                if camper.isArchived {
                    ArchivedCamperView(camper: camper)
                }
            }
        }
        .padding([.top, .bottom])
        .toolbar() {
            ToolbarItem {
                Button(action: { addingCamper.toggle() }) {
                    Image(systemName: "plus")
                }
            }
        }
        .modifier(BackgroundView())
        .sheet(isPresented: $addingCamper) {
            AddCamperView()
                .environmentObject(viewModel)
        }
        .navigationTitle("Campers")
    }
}

struct CampersView_Previews: PreviewProvider {
    static var previews: some View {
        CampersView()
            .environmentObject(ViewModel())
    }
}
