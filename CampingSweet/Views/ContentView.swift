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

    @Default(.selectedCamperIDKey) var selectedCamperID
    @Default(.tripFilterKey) var tripFilter
    @Default(.settingsKey) var settings

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
                    } label: {
                        Label("My Campers", image: "Camper")
                    }
                    .buttonStyle(PrimaryButtonStyle(isActive: true))
                    
                    NavigationLink {
                        if selectedCamperID != nil {
                            LogBookView(camperID: selectedCamperID!, tripFilter: tripFilter)
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
                        NavigationLink {
                            HelpView()
                        } label: {
                            Image(systemName: "questionmark")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding([.bottom, .leading])
                        }
//                        Button(action: { showHelpMenu = true }) {
//                            Image(systemName: "questionmark")
//                                .font(.title)
//                                .fontWeight(.bold)
//                                .padding([.bottom, .leading])
//                        }
//                        .navigationDestination(isPresented: $showHelpMenu) {
//                            HelpView()
//                        }
                        
                        Spacer()
                        
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding([.bottom, .leading])
                        }
//                        Button(action: { changingSettings = true }) {
//                            Image(systemName: "gearshape.fill")
//                                .font(.title)
//                                .padding([.bottom, .trailing])
//                        }
//                        .navigationDestination(isPresented: $changingSettings) {
//                            SettingsView()
//                        }
                    }
                }
                .navigationTitle("CampingSweet")
            }
        }
    }
}

#Preview {
    ContentView()
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

