//
//  Preview+ModelContainer.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 9/9/25.
//

import SwiftData
import Defaults

extension ModelContainer {
    static var sample: () throws -> ModelContainer = {
        let schema = Schema([CheckListItem.self, Camper.self, LogEntry.self]) // LogEntry is inferred from Relationship between Camper and LogEntry
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true, cloudKitDatabase: .none)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        Task { @MainActor in
            Camper.insertSampleData(modelContext: container.mainContext)
            // Make the first camper the selected camper
            let camper: Camper = try! container.mainContext.fetch(FetchDescriptor<Camper>()).first!
            Defaults[.selectedCamperIDKey] = camper.id
        }
        return container
    }
}
