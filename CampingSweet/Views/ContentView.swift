//
//  ContentView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    @State private var showHelpMenu = false
    @State private var changingSettings = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                NavigationLink {
                    CamperLogView().environmentObject(viewModel)
                } label: {
                    Label("My Campers", image: "Camper")
                }
                .buttonStyle(PrimaryButtonStyle(isActive: true))
                
                NavigationLink {
                    LogBookView().environmentObject(viewModel)
                } label: {
                    Label("Log Book", systemImage: "list.bullet.rectangle.fill")
                }
                .buttonStyle(PrimaryButtonStyle(isActive: viewModel.currentCamperExists()))
                
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
                    Spacer()
                    
                    Button(action: { changingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title)
                            .padding([.bottom, .trailing])
                    }
                }
            }
            .modifier(BackgroundView())

        }
        .sheet(isPresented: $changingSettings) {
            SettingsView()
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $showHelpMenu) {
            HelpView()
        }
        .errorAlert($viewModel.userError)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
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

