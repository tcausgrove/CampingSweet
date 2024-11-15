//
//  Funcs.swift
//  MyCSVTrial
//
//  Created by Timothy Causgrove on 11/14/24.
//

import Foundation
import SwiftCSV

func convertStringToDates(inputString: String) -> (Date, Date) {
    var dateOne = Date.now
    var dateTwo = Date.now
    
    // There may or may not be spaces before and after a dash between dates; just delete them
    let newString = inputString.replacingOccurrences(of: " ", with: "")
    var firstDateString = ""
    var secondDateString = ""
    
    // FIXME: change below to use the app settings
    var dateSetting: DateFormatType = .monthFirst
    
    if newString.contains("-") {
        let index = newString.firstIndex(of: "-") ?? newString.endIndex
        firstDateString = String(newString[..<index])
        // The .index(after: index) part increments the index by one to skip the dash
        secondDateString = String(newString[newString.index(after: index)..<newString.endIndex])
    } else {
        firstDateString = newString
        secondDateString = firstDateString
    }
    
    // Create Date Formatter
    let dateFormatter = DateFormatter()
    
    // Set Date Format
    dateFormatter.dateFormat = dateSetting.rawValue
    
    // Convert String to Date
    dateOne = dateFormatter.date(from: firstDateString) ?? Date.distantPast // possibly nil
    dateTwo = dateFormatter.date(from: secondDateString) ?? Date.distantFuture // possibly nil
    
    
    return (dateOne, dateTwo)
}

func getCSV(inputString: String) -> [LogEntry] {
    
    var tripDataArray: [LogEntry] = []
    
    do {
        
        let csv: CSV = try CSV<Named>(string: inputString, delimiter: .comma)
        //             let csv: CSV = try CSV<Named>(url: URL(fileURLWithPath: "CamperLog.csv"))
        //            let csv2: CSV = try EnumeratedCSV(string: theString)
        
        try csv.enumerateAsDict({ dict in
            let theDates = convertStringToDates(inputString: dict["Date"] ?? "")
            let theRowDistance: Double = Double(dict["Miles driven"] ?? "") ?? 0.0
            let rowData = LogEntry(id: UUID(),
                                   title: dict["Location"] ?? "Unknown",
                                   startDate: theDates.0, endDate: theDates.1,
                                   distance: theRowDistance)
//            let rowData = tripData(arrivalDate: theRowArriveDate, departDate: theRowDepartDate, locate: dict["Location"] ?? "Unknown", distance: theRowDistance)
//                userData.append(rowData)
            tripDataArray.append(rowData)
        })
        return tripDataArray
        
    } catch {
        return []
    }
}
