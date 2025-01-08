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
            ArchivedCamperView()
        }
        .padding([.top, .bottom])
        .toolbar() {
            ToolbarItem {
                Button(action: { addingCamper.toggle() }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $addingCamper) {
            AddCamperView()
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

struct ArchivedCamperView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        
        if viewModel.hasArchivedCampers() {
            Text("Archived campers")
                .font(.title2)
                .bold()
        }
        
        Section {
            ForEach(viewModel.campers) { camper in
                if camper.isArchived {
                    HStack {
                        Text(camper.name)
                            .font(.title3)
                            .foregroundColor(.teal)
                        Spacer()
                        // Left below in for future "Unarchive camper" option
//                        Image(systemName: "ellipsis")
//                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    }
                    .padding([.leading, .trailing], 30)
                }
            }
            Text("") // Make a little space at the bottom
        }
    }
}
