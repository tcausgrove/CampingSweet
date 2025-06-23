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
        //            .modifier(BackgroundView())
        .sheet(isPresented: $addingCamper) {
            AddCamperView()
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
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SwiftDataCamper.self, configurations: config)
        
        let trips = [SwiftDataLogEntry(title: "Trip 1", distance: 123.4),
                     SwiftDataLogEntry(title: "Trip 2", distance: 234.5)]
        let previewCamper1 = SwiftDataCamper(name: "Preview camper", isDefaultCamper: false, isArchived: false, registrationNumber: "TX", trips: trips)
        let previewCamper2 = SwiftDataCamper(name: "Archived camper", isDefaultCamper: false, isArchived: true, registrationNumber: "TX", trips: trips)
        container.mainContext.insert(previewCamper1)
        container.mainContext.insert(previewCamper2)
        return CampersView()
            .modelContainer(container)
    } catch {
        return Text("Can't do it")
    }
    
}
