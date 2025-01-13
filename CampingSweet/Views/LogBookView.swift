//
//  LogBookView.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI

struct LogBookView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var addingLogEntry = false
    @State private var editingLogEntry: Bool = false
    @State private var checkForDelete = false
    @State private var isImporting: Bool = false

    @State private var document: MessageDocument = MessageDocument(message: "Hello, World!")
    
    @State var tripToEdit: LogEntry? = nil

    var body: some View {
        NavigationView {
            VStack {
                Text("For camper \(viewModel.getCurrentCamperName())")
                    .font(.title2)
                List {
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
                }
                .toolbar() {
                    ToolbarItem {
                        Button(action: {
                            addingLogEntry.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: { isImporting = true }) {
                            Text("Import CSV")
                        }
                    }
                }
                .sheet(isPresented: $addingLogEntry, content: {
                    // change "false" to a variable and use the actual trip ID
                    AddLogBookEntryView()
                        .environmentObject(viewModel)
                })
                .sheet(isPresented: $editingLogEntry, content: {
                    EditLogEntryView(previousLogEntry: $tripToEdit)
                        .environmentObject(viewModel)
                })
            .navigationTitle("Log Book")
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
                                                         dateFormat: viewModel.settings.chosenDateFormat)
                    viewModel.addImportedTrips(newTrips: newTripData)
                } catch {
                    // Handle failure.
                }
            }
        }
    }
}

struct LogBookView_Previews: PreviewProvider {
    static var previews: some View {
        LogBookView(tripToEdit: LogEntry.example)
            .environmentObject(ViewModel())
    }
}

struct TripCardView: View {
    var trip: LogEntry
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Title:  \(trip.title)")
            Text("When:  \(trip.startDate.formatted(date: .long, time: .omitted))")
            let numberOfNightsText = "Number of nights:  " + String(trip.numberOfNights)
            Text(numberOfNightsText)
            let tripDistance = viewModel.formatDistanceBySetting(distance: trip.distance ?? 0.0)
            Text("Distance:  " + tripDistance )
        }
        .padding(.top, 12)
    }
}
