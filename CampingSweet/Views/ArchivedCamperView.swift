//
//  ArchivedCamperView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/12/25.
//

import SwiftUI
import SwiftData

struct ArchivedCamperView: View {
    @Bindable var camper: SwiftDataCamper

    @State private var showModMenu = false
    
    var body: some View {        
        CardView(cornerRadius: 10, backgroundColor: .sheetButtonBackground, padding: 6) {
            HStack {
                Text(camper.name)
                    .font(.title3)
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.title)
                    .onTapGesture { showModMenu = true }
            }
            .popover(isPresented: $showModMenu,
                     attachmentAnchor: .point(.trailing),
                     content: { popoverContents })
            .padding([.leading, .trailing], 12)
        }
    }
    
    @ViewBuilder var popoverContents: some View {
        VStack {
            Button(role: .none) {
                camper.isArchived = false
            } label: {
                Text("Unarchive")
            }
            .padding(.bottom, 8)
            Button(role: .destructive) {
            } label: {
                Text("Delete")
            }
        }
        .padding(12)
        .presentationCompactAdaptation(.popover)
    }
}

#Preview {
    ArchivedCamperView(camper: SwiftDataCamper(name: "Preview camper", isArchived: true))
}
