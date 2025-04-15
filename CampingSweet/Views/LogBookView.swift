//
//  LogBookView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI

struct LogBookView: View {
    @EnvironmentObject var viewModel: ViewModel
    
//    @State private var addingLogEntry = false
    @State private var editingLogEntry: Bool = false
    @State private var checkForDelete = false
    @State private var isImporting: Bool = false

    @State private var document: MessageDocument = MessageDocument(message: "Hello, World!")
    
    @State var tripToEdit: LogEntry? = nil

    var body: some View {
            VStack {
                Text("For camper \(viewModel.getCurrentCamperName())")
                    .font(.title2)
                Button(action: { isImporting = true }) {
                    Text("Import CSV")
                }
                    let camper = viewModel.getCurrentCamper()
                    if camper != nil {
                        ForEach(camper!.trips) { trip in
                            TripCardView(trip: trip)
                                .environmentObject(viewModel)
                                .onLongPressGesture(perform: {
                                    tripToEdit = trip       
                                    editingLogEntry.toggle()
                                    })
                        }
                        .onDelete { indexSet in
                            checkForDelete = true
                            viewModel.deleteTrips(indexSet: indexSet)
                        }
                    }
                Spacer()
            }
            .padding([.top, .bottom])
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
            .modifier(BackgroundView())
        //FIXME:  These two sheets should be combined
//            .sheet(isPresented: $addingLogEntry, content: {
                // change "false" to a variable and use the actual trip ID
//                EditLogEntryView(previousLogEntry: $tripToEdit)
//                    .environmentObject(viewModel)
//            })
            .sheet(isPresented: $editingLogEntry, content: {
                EditLogEntryView(previousLogEntry: $tripToEdit)
                    .environmentObject(viewModel)
            })
            .navigationTitle("Log Book")
    }
}

struct LogBookView_Previews: PreviewProvider {
    static var previews: some View {
        LogBookView(tripToEdit: LogEntry.example)
            .environmentObject(ViewModel())
    }
}
