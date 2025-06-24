//
//  LogBookBottomBarView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 5/12/25.
//

import SwiftUI
//import SwiftData

struct LogBookBottomBarView: View {
    @Binding var isImporting: Bool
    var camper: SwiftDataCamper
    
    var body: some View {
        HStack {
            Button("Import CSV") {
                isImporting = true
            }
            Spacer()
            Button("Export CSV") {
                saveCSVImperatively(camper: camper)
            }
//                ShareLink(item:generateCSV(camper: camper)) {
//                    Label("Export CSV", systemImage: "list.bullet.rectangle.portrait")
//                }
        }
        .padding([.leading, .trailing], 30)
        .padding(.top, 12)
        .background(.sheetButtonBackground)
    }
}

#Preview {
    LogBookBottomBarView(isImporting: .constant(false),
                         camper: SwiftDataCamper(name: "Foo", isDefaultCamper: false, isArchived: false, registrationNumber: "None", trips: []))
}
