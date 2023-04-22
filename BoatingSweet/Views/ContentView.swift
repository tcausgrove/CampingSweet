//
//  ContentView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State private var changingSettings = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
//                if(true) {
                Section {
                    NavigationLink {
                        LogBookView().environmentObject(viewModel)
                    } label: {
                        Label("Log Book", systemImage: "list.bullet.rectangle.fill")
                    }
                    .buttonStyle(PrimaryButtonStyle(isActive: viewModel.currentBoatExists()))
                    
                    NavigationLink {
                        FuelLogView().environmentObject(viewModel)
                    } label: {
                        Label("Fuel Log", systemImage: "fuelpump")
                    }
                    .buttonStyle(PrimaryButtonStyle(isActive: viewModel.currentBoatExists()))
                }
                .disabled(!viewModel.currentBoatExists())
                
                NavigationLink {
                    VesselLogView().environmentObject(viewModel)
                } label: {
                    Label("My Vessels", systemImage: "sailboat")
                }
                .buttonStyle(PrimaryButtonStyle(isActive: true))
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: { }) {
                        Image(systemName: "plus")
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
        }
        .sheet(isPresented: $changingSettings, content: { SettingsView() })
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
            .font(.title)
            .fontWeight(.bold)
            .background(isActive ? (configuration.isPressed ? Color.teal.opacity(0.5) : Color.teal) : Color.gray)
            .foregroundColor(.white)
    }
}

