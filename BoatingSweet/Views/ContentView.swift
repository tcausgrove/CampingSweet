//
//  ContentView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
     
    var body: some View {
        NavigationView() {
            VStack {
                if(viewModel.currentBoatExists() ) {
                    NavigationLink("Log Book", destination: LogBookView().environmentObject(viewModel))
                        .buttonStyle(PrimaryButtonStyle())
                    NavigationLink("Fuel Log", destination: FuelLogView().environmentObject(viewModel))
                        .buttonStyle(PrimaryButtonStyle())
                } else {
                    Text("Log Book")
                        .modifier(DisabledTextStyle())
                    Text("Fuel Log")
                        .modifier(DisabledTextStyle())
//                        .disabledTextStyle()  should also work with the extension below
                }
                NavigationLink("My Vessels", destination: VesselLogView().environmentObject(viewModel))
                    .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 300, height: 50)
            .font(.title)
            .fontWeight(.bold)
            .background(configuration.isPressed ? Color.teal.opacity(0.5) : Color.teal)
            .foregroundColor(.white)
    }
}

struct DisabledTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 300, height: 50)
            .font(.title)
            .fontWeight(.bold)
            .background(Color.gray.opacity(0.5))
            .foregroundColor(.white)
    }
}

extension View {
    func disabledTextStyle() -> some View {
        modifier(DisabledTextStyle())
    }
}
