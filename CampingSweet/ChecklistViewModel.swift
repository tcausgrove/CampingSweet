//
//  ChecklistViewModel.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 3/2/24.
//

import Foundation

@MainActor class ChecklistViewModel: ObservableObject {
    
    @Published private(set) var checklist: [ChecklistItem]
    @Published var checklistError: UserError? = nil
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "checklist") {
            if let decoded = try? JSONDecoder().decode([ChecklistItem].self, from: data) {
                checklist = decoded
                return
            }
        }
        checklistError = .failedLoading
        checklist = []
    }
    
    func addItem(newItemName: String) {
        let newItem = ChecklistItem(id: UUID(), name: newItemName, hasCheck: false)
        checklist.append(newItem)
        save()
    }
    
    func deleteItemsByIndexSet(indexSet: IndexSet) {
        for index in indexSet {
            checklist.remove(at: index)
        }
        save()
    }
    
    func toggleCheck(item: ChecklistItem) {
        if let index = checklist.firstIndex(of: item) {
            var newItem = checklist[index]
            newItem.hasCheck.toggle()
            checklist[index] = newItem
        }
        save()
    }
    
    func removeAllChecks() {
        for item in checklist {
            if item.hasCheck {
                var newItem = item
                newItem.hasCheck.toggle()
                if let index = checklist.firstIndex(of: item) {
                    checklist[index] = newItem
                }
            }
        }
        save()
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(checklist) {
            UserDefaults.standard.set(encoded, forKey: "checklist")
        } else {
            //FIXME:  need an error option here
            checklistError = .failedSaving
        }
    }
}
