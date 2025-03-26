//
//  Funcs.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 11/14/24.
//

import Foundation
import SwiftCSV
import CoreLocation

func convertStringToDates(inputString: String, dateFormat: DateFormatType) -> (Date, Date) {
    var arrivalDate = Date.now
    var departureDate = Date.now
    
    // There may or may not be spaces before and after a dash between dates; just delete them
    let newString = inputString.replacingOccurrences(of: " ", with: "")
    var firstDateString = ""
    var secondDateString: String? = nil
    
    // Date format depends on app settings
    let dateSetting: DateFormatType = dateFormat
    
    if newString.contains("-") {
        // Data includes a date range
        let index = newString.firstIndex(of: "-") ?? newString.endIndex
        firstDateString = String(newString[..<index])
        // The .index(after: index) part increments the index by one to skip the dash
        secondDateString = String(newString[newString.index(after: index)..<newString.endIndex])
    } else {
        firstDateString = newString
        //Keep second date string at nil
    }
    
    // Create Date Formatter
    let dateFormatter = DateFormatter()
    
    // Set Date Format
    dateFormatter.dateFormat = dateSetting.rawValue
    
    // Convert String to Date
    let today = Date.now
    let yesterday = today.yesterday
    arrivalDate = dateFormatter.date(from: firstDateString) ?? yesterday // possibly nil
    
    if secondDateString != nil {
        departureDate = dateFormatter.date(from: secondDateString!) ?? today // possibly nil
    } else {
        departureDate = arrivalDate.advanced(by: 86400)  // Number of seconds in one day
    }
    
    return (arrivalDate, departureDate)
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
            let theLocationString: String = dict["Coordinates"] ?? ""
            if theLocationString != "" {
                if locationType == .dms {
                    theLocation = CLLocationCoordinate2D(dmsString: theLocationString) // Custom written extension to CLLocationCoordinate2D; see Extensions file
                } else {
                    theLocation = CLLocationCoordinate2D(ddString: theLocationString)  // Custom written extension to CLLocationCoordinate2D; see Extensions file
                }
                
            }
            let theRowDistance: Double = Double(dict["Miles driven"] ?? "") ?? 0.0
            let rowData = LogEntry(id: UUID(),
                                   title: dict["Location"] ?? "Unknown",
                                   startDate: theDates.0,
                                   endDate: theDates.1,
                                   distance: theRowDistance,
                                   latitude: theLocation?.latitude,
                                   longitude: theLocation?.longitude)
            tripDataArray.append(rowData)
        })
        return tripDataArray
        
    } catch {
        return []
    }
}
