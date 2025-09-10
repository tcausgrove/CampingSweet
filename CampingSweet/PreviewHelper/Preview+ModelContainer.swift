//
//  Preview+ModelContainer.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 9/9/25.
//

import SwiftData

extension ModelContainer {
    static var sample: () throws -> ModelContainer = {
        let schema = Schema([CheckListItem.self, SwiftDataCamper.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        Task { @MainActor in
            SwiftDataCamper.insertSampleData(modelContext: container.mainContext)
        }
        return container
    }
}
