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
                    VStack {
                        HStack {
                            Button(action: { addingCamper.toggle() }) {
                                Image(systemName: "plus")
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding([.bottom, .leading, .trailing], 20)

                        if campers.isEmpty {
                            Text("Use the plus button above to add your first camper")
                                .padding(40)
                        } else {
                            ScrollView {
                                ForEach(campers, id: \.id) { camper in
                                    if !camper.isArchived {
                                        CamperCardView(camper: camper)
                                            .padding(.bottom, 8)
                                            .onTapGesture {
                                                setSelectedCamper(camper: camper)
                                            }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if hasArchivedCampers() {
                            Text("Archived campers")
                                .padding(.top, 24)
                                .font(.title)
                            ForEach(campers) { camper in
                                if camper.isArchived {
                                    ArchivedCamperView(camper: camper)
                                }
                            }
                        }
                    }
                    .padding([.top, .bottom])
                    .sheet(isPresented: $addingCamper) {
                        AddCamperView()
                    }
                    .background(BackgroundView()).scrollContentBackground(.hidden)
                    .navigationTitle("Campers")
    }
    
    func addCamper() {
        let camper = Camper(id: UUID())
        // Set to be selected camper
        selectedCamperID = camper.id
        modelContext.insert(camper)
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
