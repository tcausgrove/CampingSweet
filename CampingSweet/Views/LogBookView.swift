//
//  LogBookView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI
import SwiftData

struct LogBookView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var viewModel: ViewModel

    @Query(sort: \SwiftDataLogEntry.startDate,
           order: .reverse) var trips: [SwiftDataLogEntry]
    @State private var path = [SwiftDataCamper]()
    @State private var editingLogEntry: Bool = false
    @State private var isExporting: Bool = false
    @State var tripToEdit: SwiftDataLogEntry? = nil
    
    var body: some View {
        ScrollView {
            NavigationStack(path: $path) {
                ForEach(trips) { trip in
                    TripCardView(logEntry: trip)
//                       .onLongPressGesture(perform: {
//                            tripToEdit = trip
//                            editingLogEntry.toggle()
//                        })
                }
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            LogBookBottomBarView(camper: SwiftDataCamper.selectedCamper(with: modelContext))
        })
        .toolbar() {
            ToolbarItem {
                Button(action: {
                    tripToEdit = nil
                    editingLogEntry.toggle()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
//        .modifier(BackgroundView())
        .sheet(isPresented: $editingLogEntry, content: {
            EditLogEntryView(previousLogEntry: tripToEdit)
        })
//        .sheet(isPresented: $isExporting, content: {})
        .navigationTitle("Log Book")
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SwiftDataCamper.self, configurations: config)
        
        let trips = [SwiftDataLogEntry(title: "Trip 1", distance: 123.4),
                     SwiftDataLogEntry(title: "Trip 2", distance: 234.5)]
        let previewCamper = SwiftDataCamper(name: "Preview camper", isDefaultCamper: 0, isArchived: false, registrationNumber: "TX", trips: trips)
        
        return LogBookView()
            .modelContainer(container)
            .environmentObject(ViewModel())
    } catch {
        return Text("Can't do it")
    }
    
}
