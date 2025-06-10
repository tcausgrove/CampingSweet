//
//  ViewModel.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import Foundation
import MapKit

struct LogEntry: Identifiable, Hashable, Codable {
    var id: UUID
    var title: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    // The stored distance will be in miles, using conversions to and from for display
    var distance: Double?
    var latitude: Double?
    var longitude: Double?
    
    var numberOfNights: Int {
        let number = ((endDate - startDate) / 24 / 3600).rounded()
        return Int(number)
    }
    
    static let example = LogEntry(id: UUID(),
                                  title: "Cimarron trip",
                                  startDate: Date.now,
                                  endDate: Date.now,
                                  distance: 123.4,
                                  latitude: 36.5460278,
                                  longitude: -105.133778)
    
    var coordinate: CLLocationCoordinate2D? {
        if (latitude != nil) && (longitude != nil) {
            return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        }
        else { return nil }
    }
}

struct Camper: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var isDefaultCamper: Bool
    var isArchived: Bool
    var registrationNumber: String
    var trips: [LogEntry]
    
    var totalCamperDistance: Double {    //  This will be in miles
        var tempDistance = 0.0
        for trip in trips {
            let tripDistance = trip.distance ?? 0.0
            tempDistance = tempDistance + tripDistance
        }
        return tempDistance
    }
    
    var totalCamperNights: Int {
        var tempNights: Int = 0
        for trip in trips {
            tempNights += trip.numberOfNights
        }
        return tempNights
    }
    
    static let example = Camper(id: UUID(),
                                name: "nano",
                                isDefaultCamper: false,
                                isArchived: false,
                                registrationNumber: "TX12345",
                                trips: [LogEntry.example])
}

struct Settings: Codable {
    var chosenDistance: DistanceOptions
    var chosenClockHours: ClockHours
    var chosenDateFormat: DateFormatType
    var locationImportFormat: LocationImportFormat
    var dateImportFormat: DateImportFormat
    
    static let example = Settings(chosenDistance: .mi,
                                  chosenClockHours: .two,
                                  chosenDateFormat: .monthFirst,
                                  locationImportFormat: .dd,
                                  dateImportFormat: .startEnd)
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
