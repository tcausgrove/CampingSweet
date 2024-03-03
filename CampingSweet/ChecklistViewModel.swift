//
//  ChecklistViewModel.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 3/2/24.
//

import Foundation

@MainActor class ChecklistViewModel: ObservableObject {
    @Published private(set) var checklist: [ChecklistItem]
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "checklist") {
            if let decoded = try? JSONDecoder().decode([ChecklistItem].self, from: data) {
                checklist = decoded
                return
            }
        }
        // unable to get checklist
        checklist = []
    }
    
    func addItem(newItemName: String) {
        let newItem = ChecklistItem(id: UUID(), name: newItemName, hasCheck: false)
        checklist.append(newItem)
        save()
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(checklist) {
            UserDefaults.standard.set(encoded, forKey: "checklist")
        }
    }
}
