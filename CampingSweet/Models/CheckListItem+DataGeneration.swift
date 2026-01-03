//
//  CheckListItem+DataGeneration.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 12/29/25.
//

import Foundation
import SwiftData

extension CheckListItem {
    static func generateSampleData(modelContext: ModelContext) {
        let item0 = CheckListItem(name: "Turn off propane", hasCheck: false)
        let item1 = CheckListItem(name: "Close roof vent", hasCheck: true)
        let item2 = CheckListItem(name: "Stow stairs", hasCheck: false)
        
        modelContext.insert(item0)
        modelContext.insert(item1)
        modelContext.insert(item2)
    }
}
