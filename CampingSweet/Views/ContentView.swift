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
    
//    @Default(.selectedCamperIDKey) var selectedCamperID
    @Default(.tripFilterKey) var tripFilter
    @Default(.settingsKey) var settings
    @Default(.detailSelectionKey) var tabSelection
    
    @State private var showHelpMenu = false
    @State private var changingSettings = false
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Tab(TabList.campers.rawValue, image: "Camper", value: TabList.campers) {
                CampersView()
            }
            
            Tab(TabList.logbook.rawValue, systemImage: "list.bullet.rectangle", value: TabList.logbook) {
                LogBookView(localCamper: campers.first(where: { $0.id == selectedCamperID! }) )
            }
            .hidden(selectedCamperID == nil)
            
            Tab(TabList.maps.rawValue, systemImage: "map", value: TabList.maps) {
                MapsView(yearToMap: "All years")
            }
            
            Tab(TabList.charts.rawValue, systemImage: "chart.bar.xaxis", value: TabList.charts) {
                ChartsView()
            }
            
            TabSection("Utilities") {
                Tab(TabList.checklist.rawValue, systemImage: "checklist", value: TabList.checklist) {
                    ChecklistView()
                }
                
                Tab(TabList.settings.rawValue, systemImage: "gear", value: TabList.settings) {
                    SettingsView()
                }
                
                Tab(TabList.help.rawValue, systemImage: "questionmark", value: TabList.help) {
                    HelpView()
                }
            }
        }
        .tabViewStyle(.tabBarOnly)
    }
}


#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        ContentView()
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
