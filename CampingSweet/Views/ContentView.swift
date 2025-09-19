//
//  ContentView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI
import SwiftData
import Defaults

struct ContentView: View {
    @Query var campers: [SwiftDataCamper]
    
    @Environment(\.modelContext) var modelContext

    @StateObject var viewModel = ViewModel()
    @Default(.selectedCamperIDKey) var selectedCamperID
    @Default(.tripFilterKey) var tripFilter

    @State private var showHelpMenu = false
    @State private var changingSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack {
                    Spacer()
                    
                    NavigationLink {
                        CampersView()
                            .environmentObject(viewModel)
                    } label: {
                        Label("My Campers", image: "Camper")
                    }
                    .buttonStyle(PrimaryButtonStyle(isActive: true))
//                    .navigationDestination(for: SwiftDataCamper.self) {_ in
//                        CampersView()
//                    }
                    
                    NavigationLink {
                        let camper = SwiftDataCamper.selectedCamperFromID(with: modelContext, selectedCamperID: selectedCamperID)
                        if camper != nil {
                            LogBookView(camper: camper!, tripFilter: tripFilter)  //  Force unwrap b/c disabled if nil
                                .environmentObject(viewModel)
                        }
                    } label: {
                        Label("Log Book", systemImage: "list.bullet.rectangle.fill")
                    }
                    .buttonStyle(PrimaryButtonStyle(isActive: selectedCamperID != nil))
                    
                    NavigationLink {
                        ChecklistView()
                    } label: {
                        Label("Departure checklist", systemImage: "checklist")
                    }
                    .buttonStyle(PrimaryButtonStyle(isActive: true))
                    
                    Spacer()
                }
                
                .padding(2)
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: { showHelpMenu = true }) {
                            Image(systemName: "questionmark")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding([.bottom, .leading])
                        }
                        .navigationDestination(isPresented: $showHelpMenu) {
                            HelpView()
                        }
                        Spacer()
                        
                        Button(action: { changingSettings = true }) {
                            Image(systemName: "gearshape.fill")
                                .font(.title)
                                .padding([.bottom, .trailing])
                        }
                        .navigationDestination(isPresented: $changingSettings) {
                            SettingsView()
                        }
                    }
                }
                .navigationTitle("CampingSweet")
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
        .modelContainer(try! ModelContainer.sample())
}

struct PrimaryButtonStyle: ButtonStyle {
    var isActive: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 300, height: 50, alignment: .leading)
            .font(.title2)
            .fontWeight(.bold)
            .background(isActive ? (configuration.isPressed ? Color.mainButtonBackground.opacity(0.5) : Color.mainButtonBackground) : Color.gray)
            .foregroundColor(.white)
    }
}

