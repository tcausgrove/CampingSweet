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
    @Environment(\.modelContext) var modelContext
    
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
                        label: { Image(systemName: "plus")
                            .foregroundColor(Color.blue)}
                    )
                }
            }
            .listStyle(PlainListStyle())
            .padding()
//            .modifier(BackgroundView())
            .toolbar() {
                ToolbarItem {
                    Button(action: {
                        for anItem in checklist {
                            anItem.hasCheck = false
                        }
                    } ) { Text("Clear ✓")
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
        TextField("New item", text: $newItemName)
            .onAppear(perform: { editingFocused = true })
            .focused($editingFocused)
            .onSubmit {
                submitNewItem() }
    }
    
    func submitNewItem() {
        if newItemName.isEmpty { return }
        let newItem = CheckListItem(name: newItemName, hasCheck: false)
        modelContext.insert(newItem)
        newItemName = ""
        addingItem = false
    }
    
    func deleteItems(_ indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = checklist[index]
            modelContext.delete(itemToDelete)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CheckListItem.self, configurations: config)
        
        return ChecklistView()
            .modelContainer(container)
    } catch {
        return Text("Can't do it")
    }
}
