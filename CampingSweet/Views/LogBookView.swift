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
    
    var selectedCamperName: String 
    
    init(selectedCamperName: String) {
        self.selectedCamperName = selectedCamperName
        let predicate = #Predicate<SwiftDataLogEntry> { trip in
            trip.camper?.name == selectedCamperName
        }
        _trips = Query(filter: predicate, sort: \SwiftDataLogEntry.startDate, order: .reverse)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
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
            .navigationTitle("Log Book")
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        LogBookView(selectedCamperName: "Preview Camper A")
        .environmentObject(ViewModel())
    }
}
