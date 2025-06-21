//
//  LogBookView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import SwiftUI
import SwiftData

struct LogBookView: View {
//    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    @Bindable var camper: SwiftDataCamper
//    let trips = [SwiftDataLogEntry(title: "Trip 1", distance: 123.4),
//                 SwiftDataLogEntry(title: "Trip 2", distance: 234.5)]
    
    //    @State private var addingLogEntry = false
    @State private var editingLogEntry: Bool = false
    @State private var checkForDelete = false
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    
    @State private var document: MessageDocument = MessageDocument(message: "")
    
    @State var tripToEdit: SwiftDataLogEntry? = nil
    
    var body: some View {
        VStack {
            HStack {
//                Text("For camper \(camper.name)")
//                    .font(.title2)
            }
            ScrollView {
                ForEach(camper.trips) { trip in
                    TripCardView(trip: trip)
//                        .environmentObject(viewModel)
                       .onLongPressGesture(perform: {
                            tripToEdit = trip
                            editingLogEntry.toggle()
                        })
                }
                //FIXME:  Deleting a trip doesn't work; swipe left does nothing; plan is add a Delete button in EditLogBookView
                .onDelete { indexSet in
                    checkForDelete = true
//                    viewModel.deleteTrips(indexSet: indexSet)
                }
            }
            Spacer()
//            LogBookBottomBarView(isImporting: $isImporting, camper: camper)
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
//            handleCSVFileImport(result: result)
        }
//        .modifier(BackgroundView())
        .sheet(isPresented: $editingLogEntry, content: {
            EditLogEntryView(previousLogEntry: tripToEdit)
//                .environmentObject(viewModel)
        })
//        .sheet(isPresented: $isExporting, content: {})
        .navigationTitle("Log Book")
    }
    
//    func handleCSVFileImport(result: Result<[URL], any Error>) {
//        do {
//            guard let selectedFile: URL = try result.get().first else { return }
//            guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
            
//            document.message = message
//            let newTripData: [LogEntry] = getCSV(inputString: document.message,
//                                                 dateFormat: viewModel.settings.chosenDateFormat,
//                                                 locationType: viewModel.settings.locationImportFormat,
//                                                 dateImportFormat: viewModel.settings.dateImportFormat)
//            viewModel.addImportedTrips(newTrips: newTripData)
//        } catch {
            // FIXME:  Need to handle failure here
//        }
//    }
}


//struct LogBookView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogBookView(camper: SwiftDataCamper(name: "Preview", isDefaultCamper: false, isArchived: true))
//            .environmentObject(ViewModel())
//    }
//}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SwiftDataCamper.self, configurations: config)
        
        return LogBookView(camper: SwiftDataCamper(name: "Preview camper", isDefaultCamper: false, isArchived: false, registrationNumber: "TX"))
            .modelContainer(container)
    } catch {
        return Text("Can't do it")
    }

}
