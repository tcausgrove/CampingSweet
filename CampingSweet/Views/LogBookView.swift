//
//  LogBookView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI

struct LogBookView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    //    @State private var addingLogEntry = false
    @State private var editingLogEntry: Bool = false
    @State private var checkForDelete = false
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    
    @State private var document: MessageDocument = MessageDocument(message: "")
    
    @State var tripToEdit: LogEntry? = nil
    
    var body: some View {
        VStack {
            let camper = viewModel.getCurrentCamper() ?? Camper.example
            HStack {
                Text("For camper \(camper.name)")
                    .font(.title2)
            }
            ScrollView {
                ForEach(camper.trips) { trip in
                    TripCardView(trip: trip)
                        .environmentObject(viewModel)
                        .onLongPressGesture(perform: {
                            tripToEdit = trip
                            editingLogEntry.toggle()
                        })
                }
                //FIXME:  Deleting a trip doesn't work; swipe left does nothing
                .onDelete { indexSet in
                    checkForDelete = true
                    viewModel.deleteTrips(indexSet: indexSet)
                }
            }
//            .padding([.top, .bottom])
            Spacer()
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
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.plainText],
            allowsMultipleSelection: false
        ) { result in
            handleCSVFileImport(result: result)
        }
        .modifier(BackgroundView())
        .sheet(isPresented: $editingLogEntry, content: {
            EditLogEntryView(previousLogEntry: $tripToEdit)
                .environmentObject(viewModel)
        })
        .sheet(isPresented: $isExporting, content: {})
        .navigationTitle("Log Book")
    }
    
    func handleCSVFileImport(result: Result<[URL], any Error>) {
        do {
            guard let selectedFile: URL = try result.get().first else { return }
            guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
            
            document.message = message
            let newTripData: [LogEntry] = getCSV(inputString: document.message,
                                                 dateFormat: viewModel.settings.chosenDateFormat,
                                                 locationType: viewModel.settings.locationImportFormat,
                                                 dateImportFormat: viewModel.settings.dateImportFormat)
            viewModel.addImportedTrips(newTrips: newTripData)
        } catch {
            // FIXME:  Need to handle failure here
        }
    }
}

struct LogBookView_Previews: PreviewProvider {
    static var previews: some View {
        LogBookView(tripToEdit: LogEntry.example)
            .environmentObject(ViewModel())
    }
}
