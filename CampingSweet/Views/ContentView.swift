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
    @State private var selection: ViewList? = nil
    
    var body: some View {
        NavigationSplitView {
                VStack {
                    List(ViewList.allCases, id: \.self, selection: $selection) { destination in
                        NavigationLink(value: destination, label: { Text(verbatim: destination.rawValue)})
                    }
                .navigationTitle("CampingSweet")
            }
        } detail: {
            switch selection {
            case .campers:
                CampersView()
            case .logbook:
                if selectedCamperID == nil {
                    ContentUnavailableView("No camper selected", systemImage: "exclamationmark.octagon", description: Text("Please select a camper from the Campers option"))
                } else {
                    LogBookView(localCamperID: selectedCamperID!)
                }
            case .maps:
                MapsView(yearToMap: "All years")
            case .charts:
                ChartsView()
            case .checklist:
                ChecklistView()
            case .settings:
                SettingsView()
            case .help:
                HelpView()
            case nil:
                ContentUnavailableView("Choose an option", systemImage: "exclamationmark.octagon")
            }
        }
        .environment(navigationManager)
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
