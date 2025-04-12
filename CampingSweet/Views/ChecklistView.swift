//
//  ChecklistView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 7/28/23.
//

import SwiftUI

struct ChecklistView: View {
    
    @StateObject var checklistViewModel = ChecklistViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var addingItem: Bool = false
    @State private var newItemName = ""
    @FocusState var editingFocused: Bool
    
    var body: some View {
            List {
                ForEach(checklistViewModel.checklist, id: \..id) { item in
                    HStack {
                        if item.hasCheck { showCheckMark() }
                        Text(item.name)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        checklistViewModel.toggleCheck(item: item)
                        checklistViewModel.save()
                    }
                }
                .onDelete(perform: { indexSet in
                    checklistViewModel.deleteItemsByIndexSet(indexSet: indexSet)
                })

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
                        checklistViewModel.removeAllChecks()
                    } ) { Image(systemName: "trash")
                    }
                }
            }
            .navigationTitle("Departure checklist")
        .errorAlert($checklistViewModel.checklistError)
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
        checklistViewModel.addItem(newItemName: newItemName)
        newItemName = ""
    }
}

struct ChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView()
            .environmentObject(ViewModel())
    }
}
