//
//  CSVImportExport.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 11/6/25.
//

import SwiftUI
import UniformTypeIdentifiers
import CodableCSV
import CoreLocation
import SwiftCSV


// Required by .fileExporter extension
struct TextFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.plainText]

    // by default our document is empty
    var text = ""

    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}


// Function below uses the CodableCSV package
// Not being used; superseded by fileExporterCSVSaver because
//   this routine saves only to documentDirectory; I want to present a file dialog
func saveCSVImperatively(camper: Camper) -> UserError? {
    var writer: CSVWriter!
    
    do {
        let path = try FileManager.default.url(for: .documentDirectory,
                                               in: .allDomainsMask,
                                               appropriateFor: nil,
                                               create: false)
        
        let fileURL = path.appendingPathComponent("\(camper.name)_trips.csv")
        writer = try CSVWriter(fileURL: fileURL)
    } catch {
        return .couldNotSaveCSV
    }
    do {
        let heading = ["Date", "Nights", "Location", "Coordinates", "Miles driven"]
        try writer.write(row: heading)
        
        for trip in camper.trips {
            let titleString = trip.title
            let datesString = convertDatesToString(arrival: trip.startDate, departure: trip.endDate)
            let nightsString = "\(trip.numberOfNights)"
            let milesString = "\(trip.distance ?? 0.0)"
            let locationString = "\(trip.latitude ?? 0.0) \(trip.longitude ?? 0.0)"
            let row = [datesString, nightsString, titleString, locationString, milesString]
            try writer.write(row: row)
        }
        try writer.endEncoding()
    } catch {
        return .couldNotSaveCSV
    }
    return .exportCSVSucceeded
}

func fileExporterCSVSaver(camper: Camper) -> TextFile {
    // This can be written better.  See https://developer.apple.com/documentation/swift/preserving-the-results-of-a-throwing-expression and
    // https://learn-swift.com/the-result-type/ to return both error on failure and the file on success.
    var data: String = ""
    let heading = ["Date", "Nights", "Location", "Coordinates", "Miles driven"]
    do {
        let encoder = try CSVEncoder().lazy(into: String.self)
        try encoder.encodeRow(heading)
        for trip in camper.trips {
            let titleString = trip.title
            let datesString = convertDatesToString(arrival: trip.startDate, departure: trip.endDate)
            let nightsString = "\(trip.numberOfNights)"
            let milesString = "\(trip.distance ?? 0.0)"
            let locationString = "\(trip.latitude ?? 0.0) \(trip.longitude ?? 0.0)"
            let row = [datesString, nightsString, titleString, locationString, milesString]
            try encoder.encodeRow(row)
        }
        data = try encoder.endEncoding()
    } catch {
        // FIXME:  Need to handle error below
        print("couldn't do it")
    }
    var file = TextFile()
    file.text = data
    return file
}

func getCSV(inputString: String,
            dateFormat: DateFormatType,
            locationType: LocationImportFormat,
            dateImportFormat: DateImportFormat) -> [LogEntry] {
    
    var tripDataArray: [LogEntry] = []
    
    do {
        let csv: CSV = try CSV<Named>(string: inputString, delimiter: .comma)
        
        var theLocation: CLLocationCoordinate2D? = nil
        
        try csv.enumerateAsDict({ dict in
            var theDates = convertStringToDates(inputString: dict["Date"] ?? "", dateFormat: dateFormat)
            if dateImportFormat == .startOnly {
                // read number of nights
                let numberOfNights: Int = Int(dict["Nights"] ?? "") ?? 0
                theDates.1 = theDates.0.addingTimeInterval(86400 * Double(numberOfNights))
            }
            let theLocationString: String? = dict["Coordinates"] ?? nil
            if theLocationString != "" && theLocation != nil {
                if locationType == .dms {
                    theLocation = CLLocationCoordinate2D(dmsString: theLocationString!) // Custom written extension to CLLocationCoordinate2D; see Extensions file
                } else {
                    theLocation = CLLocationCoordinate2D(ddString: theLocationString!)  // Custom written extension to CLLocationCoordinate2D; see Extensions file
                }
            }
            let theRowDistance: Double = Double(dict["Miles driven"] ?? "") ?? 0.0
            let rowData = LogEntry(title: dict["Location"] ?? "Unknown",
                                   distance: theRowDistance,
                                   startDate: theDates.0,
                                   endDate: theDates.1,
                                   latitude: theLocation?.latitude,
                                   longitude: theLocation?.longitude)
            tripDataArray.append(rowData)
        })
        return tripDataArray
        
    } catch {
        return []
    }
}

