//
//  LogBookBottomBarView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 5/12/25.
//

import SwiftUI
import SwiftData

struct LogBookBottomBarView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var isImporting: Bool = false
    @State private var document: MessageDocument = MessageDocument(message: "")
    @State private var exportResult: UserError? = nil
    var camper: SwiftDataCamper

    var body: some View {
        HStack {
            Button("Import CSV") {
                isImporting = true
            }
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [.plainText],
                allowsMultipleSelection: false
            ) { result in
                handleCSVFileImport(result: result)
            }

            Spacer()
            
            Button("Export CSV") {
                exportResult = saveCSVImperatively(camper: camper)
            }
            .disabled(camper.trips.isEmpty)
            .errorAlert($exportResult)
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
                                                          dateFormat: viewModel.settings.chosenDateFormat,
                                                          locationType: viewModel.settings.locationImportFormat,
                                                          dateImportFormat: viewModel.settings.dateImportFormat)
            for newLogEntry in newTripData {
                camper.trips.append(newLogEntry)
            }
        } catch {
            // FIXME:  Need to handle failure here
        }
    }
}

#Preview {
    LogBookBottomBarView(camper: SwiftDataCamper(name: "Foo", isArchived: false, registrationNumber: "None", trips: []))
        .environmentObject(ViewModel())
}
