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
        NavigationView {
            List {
                ForEach(checklistViewModel.checklist, id: \..id) { item in
                    Text(item.name)
                }
                
                if addingItem {
                    TextField("", text: $newItemName)
                        .onAppear(perform: { editingFocused = true })
                        .focused($editingFocused)
                        .onSubmit {
                            addingItem = false
                            if newItemName.isEmpty { return }
                            checklistViewModel.addItem(newItemName: newItemName)
                            newItemName = ""
                        }
                } else {
                    HStack {
                        Text("+")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { addingItem = true }
                }
            }
        }
    }
}

struct ChecklistView_Previews: PreviewProvider {
    @EnvironmentObject var checklistViewModel: ChecklistViewModel
    
    static var previews: some View {
        ChecklistView()
    }
}
