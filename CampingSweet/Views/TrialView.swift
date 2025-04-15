//
//  TrialView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/14/25.
//

import SwiftUI

struct MyItem: Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String
}

struct TrialView: View {
    @State private var theItems: [MyItem] = [MyItem(title: "Item 1"), MyItem(title: "Item 2")]
    
    @State private var selection: MyItem? = nil
    
    var body: some View {
        VStack {
            List(theItems, selection: $selection) { notItem in
                Text("Buy me: \(notItem.title)")
                    .tag(notItem)
            }
            .popover(item: $selection,
//                     attachmentAnchor: .point(.center),
                     arrowEdge: .trailing,
                   content: { SheetView(myItem: $0)
            })
        }
    }
}

#Preview {
    TrialView()
}

struct SheetView: View {
    let myItem: MyItem
    
    var body: some View {
        Text("You picked \(myItem.title)")
            .presentationCompactAdaptation(.popover)
    }
}
