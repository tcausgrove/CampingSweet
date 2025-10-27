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
    @Query var campers: [Camper]
    
    @Environment(\.modelContext) var modelContext
    @State private var navigationManager = NavigationManager()

    @Default(.selectedCamperIDKey) var selectedCamperID
    @Default(.tripFilterKey) var tripFilter
    @Default(.settingsKey) var settings

    @State private var showHelpMenu = false
    @State private var changingSettings = false
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            ZStack {
                BackgroundView()
                VStack {
                    Spacer()
                    
                    NavigationLink(value: ViewList.campers,
                                   label: { Label("My Campers", image: "Camper")
                    })
                    .showSubView()
                    .buttonStyle(PrimaryButtonStyle(isActive: true))
                    
                    NavigationLink(value: selectedCamperID,
                                   label: { Label("Log Book", systemImage: "list.bullet.rectangle.fill")
                    })
                    .navigationDestination(for: UUID.self) { camperID in
                            LogBookView(localCamperID: camperID, tripFilter: tripFilter) }
                    .buttonStyle(PrimaryButtonStyle(isActive: selectedCamperID != nil))
                    
                    NavigationLink(value: ViewList.checklist,
                                   label: { Label("Departure checklist", systemImage: "checklist") })
                    .showSubView()
                        .buttonStyle(PrimaryButtonStyle(isActive: true))
                    
                    Spacer()
                
                    HStack {
                    
//                .padding(2)
                        NavigationLink(value: ViewList.help,
                                       label: { Image(systemName: "questionmark").toolbarImageStyle()
                        })
                        .showSubView()
                        
                        Spacer()
                        
                        NavigationLink(value: ViewList.settings,
                                       label: { Image(systemName: "gearshape.fill").toolbarImageStyle()
                        })
                        .showSubView()
                    }
                }
                .navigationTitle("CampingSweet")
            }
        }
        .environment(navigationManager)
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

struct ToolbarViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.bold)
            .padding([.leading, .trailing], 34)
    }
}

extension View {
    func toolbarImageStyle() -> some View {
        self.modifier(ToolbarViewModifier())
    }
}
