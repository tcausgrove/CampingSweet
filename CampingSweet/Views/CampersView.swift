//
//  CamperLogView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import SwiftUI
import SwiftData

struct CampersView: View {
    @Query(sort: \SwiftDataCamper.name) var campers: [SwiftDataCamper]
    @Environment(\.modelContext) var modelContext
    @AppSettings(\.settingsSelectedCamperName) var selectedCamperName

    @State private var addingCamper: Bool = false
    @State private var path = [SwiftDataCamper]()

    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
            NavigationStack(path: $path) {
                ForEach(campers, id: \.self) { camper in
                    if !camper.isArchived {
                        CamperCardView(camper: camper)
                            .padding(.bottom, 8)
                            .onTapGesture {
                                setSelectedCamper(camper: camper)
                            }
                    }
                }
            }
                
                Spacer()
                
                if hasArchivedCampers() {
                    Text("Archived campers")
                        .font(.title2)
                        .bold()
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
            .navigationTitle("Campers")
        }
    }
    
    func addCamper() {
        let camper = SwiftDataCamper()
        // Set to be selected camper
        selectedCamperName = camper.name
        modelContext.insert(camper)
        path = [camper]
    }
    
    func setSelectedCamper(camper: SwiftDataCamper) {
        selectedCamperName = camper.name
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
            .environmentObject(ViewModel())
    }
}
