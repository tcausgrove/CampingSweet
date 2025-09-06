//
//  ContentView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var campers: [SwiftDataCamper]
    
    @Environment(\.modelContext) var modelContext
    
    @StateObject var viewModel = ViewModel()

    @State private var showHelpMenu = false
    @State private var changingSettings = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                NavigationLink {
                    CampersView()
                } label: {
                    Label("My Campers", image: "Camper")
                }
                .buttonStyle(PrimaryButtonStyle(isActive: true))
                .navigationDestination(for: SwiftDataCamper.self) {_ in 
                    CampersView()
                }
                
                NavigationLink {
                    // FIXME: With changes to the model, I shouldn't have to send a camper to LogBookView
//                    let selectedCamper = SwiftDataCamper.selectedCamper(with: modelContext)
                    LogBookView()
                } label: {
                    Label("Log Book", systemImage: "list.bullet.rectangle.fill")
                }
                .buttonStyle(PrimaryButtonStyle(isActive: campers.count > 0))
                
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
//                    Button(action: { showHelpMenu = true }) {
            //                        Image(systemName: "questionmark")
            //                            .font(.title)
            //                            .fontWeight(.bold)
            //                            .padding([.bottom, .leading])
            //                   }
            //                    .navigationDestination(isPresented: $showHelpMenu) {
            //                        HelpView()
//                   }
                    Spacer()
            
                    Button(action: { changingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title)
                           .padding([.bottom, .trailing])
                    }
                    .navigationDestination(isPresented: $changingSettings) {
                        SettingsView()
//for                            .environmentObject(viewModel)
                   }
                }
            }
            .navigationTitle("CampingSweet")
            //            .modifier(BackgroundView())
            
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SwiftDataCamper.self, configurations: config)
        
        return ContentView()
            .modelContainer(container)
            .environmentObject(ViewModel())
    } catch {
        return Text("Can't do it")
    }
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

