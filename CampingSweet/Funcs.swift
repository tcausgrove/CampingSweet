//
//  Funcs.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 11/14/24.
//

import Foundation
import CoreLocation
import MapKit

// Helper for CSV import; assumes a dash between initial and final dates
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

func convertDatesToString(arrival: Date, departure: Date?) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    
    let arrivalString = formatter.string(from: arrival)
    var departureString : String? = nil
    if departure != nil {
        departureString = formatter.string(from: departure!)
    }
    var returnString = "\(String(describing: arrivalString))"
    if departureString != nil {
        returnString += " - \(String(describing: departureString!))"
    }
    return returnString
}

func startEndDateToNights(startDate: Date, endDate: Date) -> String {
    let number = Int( ((endDate - startDate) / 24 / 3600).rounded() )
    var result: String
    if number == 1 {
        result = String( number ) + " night"
    } else {
        result = String( number ) + " nights"
    }
    return result
}

func openMapAtLocation(logEntry: LogEntry) {
    let regionDistance: CLLocationDistance = 50000
    let coordinates = CLLocationCoordinate2D(latitude: logEntry.latitude!, longitude: logEntry.longitude!)
    
    let options = [MKLaunchOptionsMapSpanKey: NSNumber(value: regionDistance)]
    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)  // Placemark is deprecated; find an alternative
    mapItem.name = logEntry.title
    mapItem.openInMaps(launchOptions: options)
}
