//
//  LogBookBottomBarView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 5/12/25.
//

import SwiftUI
import SwiftData
import Defaults

struct LogBookBottomBarView: View {
    @State private var isImporting: Bool = false
    @State private var document: MessageDocument = MessageDocument(message: "")
    @State private var actionResult: UserError? = nil
    
    @Default(.settingsKey) var settings

    var camper: SwiftDataCamper

    var body: some View {
        HStack {
            Button("Import CSV") {
                isImporting = true
            }
            .errorAlert($actionResult)
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [.plainText],
                allowsMultipleSelection: false
            ) { result in
                handleCSVFileImport(result: result)
            }

            Spacer()
            
            Button("Export CSV") {
                actionResult = saveCSVImperatively(camper: camper)
            }
            .disabled(camper.trips.isEmpty)
            .errorAlert($actionResult)
        }
        .padding([.leading, .trailing], 30)
        .padding(.top, 12)
        .background(.sheetButtonBackground)
    }
    
    func handleCSVFileImport(result: Result<[URL], any Error>) {
        do {
            guard let selectedFile: URL = try result.get().first else { return }
            guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
            
            document.message = message
            let newTripData: [SwiftDataLogEntry] = getCSV(inputString: document.message,
                                                          dateFormat: settings.chosenDateFormat,
                                                          locationType: settings.locationImportFormat,
                                                          dateImportFormat: settings.dateImportFormat)
            for newLogEntry in newTripData {
                camper.trips.append(newLogEntry)
                actionResult = .importCSVSucceeded
            }
        } catch {
            actionResult = .failedLoading
        }
    }
}

#Preview {
    LogBookBottomBarView(camper: SwiftDataCamper(id: UUID(), name: "Foo", isArchived: false, registrationNumber: "None", trips: []))
}
