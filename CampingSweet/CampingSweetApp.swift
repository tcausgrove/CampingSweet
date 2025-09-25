//
//  CampingSweetApp.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI
import SwiftData

@main
struct CampingSweetApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [CheckListItem.self, SwiftDataCamper.self])
    }
}
