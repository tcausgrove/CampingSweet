//
//  LogBookBottomBarView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 5/12/25.
//

import SwiftUI
import SwiftData

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
        .background(.sheetButtonBackground)
    }
}

//#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: SwiftDataCamper.self, configurations: config)
        
//        return LogBookBottomBarView(isImporting: false)
//            .modelContainer(container)
//    } catch {
//        return Text("Can't do it")
//    }
//}
