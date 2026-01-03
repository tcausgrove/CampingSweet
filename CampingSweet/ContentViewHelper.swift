//
//  ContentViewHelper.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 10/27/25.
//

import SwiftUI

enum ViewList: Codable {
    case campers
    case maps
    case charts
    case checklist
    case settings
    case help
}

struct ViewToShow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: ViewList.self) { screen in
                switch screen {
                case .campers:
                    return AnyView(CampersView())
                case .maps:
                    return AnyView(MapsView(yearToMap: "All years"))
                case .charts:
                    return AnyView(ChartsView())
                case .checklist:
                    return AnyView(ChecklistView())
                case .settings:
                    return AnyView(SettingsView())
                case .help:
                    return AnyView(HelpView())
                }
            }
    }
}

extension View {
    func showSubView() -> some View {
        modifier(ViewToShow())
    }
}

