//
//  CamperLogView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import SwiftUI
import SwiftData

struct CampersView: View {
    @Query var campers: [SwiftDataCamper]
    @Environment(\.modelContext) var modelContext
    
    @State private var addingCamper: Bool = false
    @State private var path = [SwiftDataCamper]()
    
    
    var body: some View {
        VStack {
            NavigationStack(path: $path) {
                ForEach(campers) { camper in
                    if !camper.isArchived {
                        CamperCardView(camper: camper)
                            .padding(.bottom, 8)
//                        .environmentObject(viewModel)
                            .onTapGesture {
                                setSelectedCamper(camper: camper)
                            }
//                            viewModel.setCurrentCamper(selectedCamperName: camper.name)
                    }
                }
            }
        }
        
        Spacer()
        
        //            if viewModel.hasArchivedCampers() {
        //                Text("Archived campers")
        //                    .font(.title2)
        //                    .bold()
        //            }
        //            ForEach(viewModel.campers) { camper in
        //                if camper.isArchived {
        //                    ArchivedCamperView(camper: camper)
        //                }
        //            }
        //        }
        //        .padding([.top, .bottom])
            .toolbar() {
                ToolbarItem {
                    Button(action: { addingCamper.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
//            .modifier(BackgroundView())
            .sheet(isPresented: $addingCamper) {
                //            Text("AddCamperView here")
                AddCamperView()
                //                .environmentObject(viewModel)
            }
            .navigationTitle("Campers")
    }
    
    func addCamper() {
        let camper = SwiftDataCamper()
        modelContext.insert(camper)
        path = [camper]
    }
    
    func setSelectedCamper(camper: SwiftDataCamper) {
        for oldCamper in campers {
            oldCamper.isDefaultCamper = false
        }
        camper.isDefaultCamper = true
        try? modelContext.save()
    }
}

struct CampersView_Previews: PreviewProvider {
    static var previews: some View {
        CampersView()
        //            .environmentObject(ViewModel())
    }
}
