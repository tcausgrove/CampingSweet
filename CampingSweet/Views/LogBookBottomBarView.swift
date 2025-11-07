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
    @State private var isExporting: Bool = false
    @State private var actionResult: UserError? = nil
    @State var exportData: TextFile = TextFile(initialText: "")
    
    @State private var document: MessageDocument = MessageDocument(message: "")
    
    @Default(.settingsKey) var settings

    var camper: Camper

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
                exportData = fileExporterCSVSaver(camper: camper)
                isExporting = true
//                actionResult = saveCSVImperatively(camper: camper)
            }
            .fileExporter(isPresented: $isExporting,
                          document: exportData,
                          contentType: .plainText,
                          defaultFilename: "\(camper.name)_log.csv") { result in
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
            let newTripData: [LogEntry] = getCSV(inputString: document.message,
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
    LogBookBottomBarView(camper: Camper(id: UUID(), name: "Foo", isArchived: false, registrationNumber: "None", trips: []))
}
