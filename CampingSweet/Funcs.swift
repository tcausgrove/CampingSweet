//
//  Funcs.swift
//  MyCSVTrial
//
//  Created by Timothy Causgrove on 11/14/24.
//

import Foundation
import SwiftCSV

func convertStringToDates(inputString: String, dateFormat: DateFormatType) -> (Date, Date) {
    var dateOne = Date.now
    var dateTwo = Date.now
    
    // There may or may not be spaces before and after a dash between dates; just delete them
    let newString = inputString.replacingOccurrences(of: " ", with: "")
    var firstDateString = ""
    var secondDateString = ""
    
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
        //FIXME: need to find a way to make secondDateString increment by one day
        secondDateString = firstDateString
    }
    
    // Create Date Formatter
    let dateFormatter = DateFormatter()
    
    // Set Date Format
    dateFormatter.dateFormat = dateSetting.rawValue
    
    // Convert String to Date
    let today = Date.now
    let yesterday = today.yesterday
    dateOne = dateFormatter.date(from: firstDateString) ?? yesterday // possibly nil
    dateTwo = dateFormatter.date(from: secondDateString) ?? today // possibly nil
    
    
    return (dateOne, dateTwo)
}

func getCSV(inputString: String, dateFormat: DateFormatType) -> [LogEntry] {
    
    var tripDataArray: [LogEntry] = []
    
    do {
        
        let csv: CSV = try CSV<Named>(string: inputString, delimiter: .comma)
        //             let csv: CSV = try CSV<Named>(url: URL(fileURLWithPath: "CamperLog.csv"))
        //            let csv2: CSV = try EnumeratedCSV(string: theString)
        
        try csv.enumerateAsDict({ dict in
            let theDates = convertStringToDates(inputString: dict["Date"] ?? "", dateFormat: dateFormat)
            let theRowDistance: Double = Double(dict["Miles driven"] ?? "") ?? 0.0
            let rowData = LogEntry(id: UUID(),
                                   title: dict["Location"] ?? "Unknown",
                                   startDate: theDates.0, endDate: theDates.1,
                                   distance: theRowDistance)
            tripDataArray.append(rowData)
        })
        return tripDataArray
        
    } catch {
        return []
    }
}
