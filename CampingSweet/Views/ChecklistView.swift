//
//  ChecklistView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 7/28/23.
//

import SwiftUI
import SwiftData

struct ChecklistView: View {
    
    @Query var checklist: [CheckListItem]
    @Environment(\.modelContext) var checklistModelContext
    
    @Environment(\.dismiss) var dismiss
    
    @State private var addingItem: Bool = false
    @State private var newItemName = ""
    @FocusState var editingFocused: Bool
    
    var body: some View {
            List {
                ForEach(checklist) { item in
                    HStack {
                        if item.hasCheck { showCheckMark() }
                        Text(item.name)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        item.hasCheck.toggle()
                    }
                }
                .onDelete(perform: deleteItems)

                if addingItem {
                    addingItemView
                } else {
                    Button(
                        action: { addingItem = true },
                        label: { Image(systemName: "plus") }
                    )
                }
            }
            .listStyle(PlainListStyle())
            .padding()
            .modifier(BackgroundView())
            .toolbar() {
                ToolbarItem {
                    Button(action: {
                        for anItem in checklist {
                            anItem.hasCheck = false
                        }
                    } ) { Image(systemName: "trash")
                    }
                }
            }
            .navigationTitle("Departure checklist")
//        .errorAlert($checklistViewModel.checklistError)
    }
    
    struct showCheckMark: View {
        var body: some View {
            Image(systemName: "checkmark")
                .foregroundColor(.green)
                .padding(.trailing, 8)
        }
    }
    
    var addingItemView: some View {
        TextField("", text: $newItemName)
            .onAppear(perform: { editingFocused = true })
            .focused($editingFocused)
            .onSubmit { submitNewItem() }
    }
    
    func submitNewItem() {
        addingItem = false
        if newItemName.isEmpty { return }
        let newItem = CheckListItem(name: newItemName, hasCheck: false)
        checklistModelContext.insert(newItem)
        newItemName = ""
    }
    
    func deleteItems(_ indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = checklist[index]
            checklistModelContext.delete(itemToDelete)
        }
    }
}

struct ChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView()
    }
}
