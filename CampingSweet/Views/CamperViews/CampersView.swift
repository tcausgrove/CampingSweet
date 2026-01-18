//
//  CamperLogView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import SwiftUI
import SwiftData
import Defaults

struct CampersView: View {
    @Query(sort: \Camper.name) var campers: [Camper]
    
    @Environment(\.modelContext) var modelContext
    @Default(.selectedCamperIDKey) var selectedCamperID
    @Default(.settingsKey) var settings

    @State private var addingCamper: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Text("Campers")
                    .font(.title)
                    .padding(12)
                
                ScrollView {
                    VStack {
                        ForEach(campers, id: \.self) { camper in
                            if !camper.isArchived {
                                CamperCardView(camper: camper)
                                    .padding(.bottom, 8)
                                    .onTapGesture {
                                        setSelectedCamper(camper: camper)
                                    }
                            }
                        }
                        
                        Spacer()
                        
                        if hasArchivedCampers() {
                            Text("Archived campers")
                                .padding(.top, 36)
                                .font(.title)
//                                .bold()
                            ForEach(campers) { camper in
                                if camper.isArchived {
                                    ArchivedCamperView(camper: camper)
                                }
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
                    .sheet(isPresented: $addingCamper) {
                        AddCamperView()
                    }
//                    .navigationBarTitle("Campers")
                }
            }
        }
    }
    
    func addCamper() {
        let camper = Camper(id: UUID())
        // Set to be selected camper
        selectedCamperID = camper.id
        modelContext.insert(camper)
//        path = [camper]
    }
    
    func setSelectedCamper(camper: Camper) {
        selectedCamperID = camper.id
        try? modelContext.save()
    }
    
    func hasArchivedCampers() -> Bool {
        for camper in campers {
            if camper.isArchived {
                return true
            }
        }
        return false
    }
}


#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        CampersView()
    }
}
