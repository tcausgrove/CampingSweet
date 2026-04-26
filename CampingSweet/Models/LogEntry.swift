//
//  LogEntry.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 6/19/25.
//

import SwiftUI
import SwiftData
import CoreLocation
import Defaults

@Model
class LogEntry {
    var title: String = ""
    var distance: Double?
    var startDate: Date
    var endDate: Date
    var latitude: Double?
    var longitude: Double?
    
    @Relationship var camper: Camper
    
    init(title: String,
         distance: Double?,
         startDate: Date,
         endDate: Date,
         latitude: Double?,
         longitude: Double?,
         camper: Camper)
    {
        self.title = title
        self.distance = distance
        self.startDate = startDate
        self.endDate = endDate
        self.latitude = latitude
        self.longitude = longitude
        self.camper = camper
    }
    
    var numberOfNights: Int {
        let number = ((endDate - startDate) / 24 / 3600).rounded()
        return Int(number)
    }
    
    var distanceMeasurement: Measurement<UnitLength>? {
        get {
            if let distance {
                return Measurement<UnitLength>(value: distance, unit: .miles)
            } else { return nil }
        }
        set { distance = newValue?.converted(to: .miles).value }
    }
    
    var location: CLLocationCoordinate2D? {
        get {
            if let latitude, let longitude {
                return CLLocationCoordinate2DMake(latitude, longitude)
            }
            else { return nil }
        }
        set {
            latitude = newValue?.latitude
            longitude = newValue?.longitude
        }
    }
    
    var hasLocationData: Bool {
        return (latitude != nil && longitude != nil)
    }
}

//  See https://developer.apple.com/documentation/swiftdata/filtering-and-sorting-persistent-data
extension LogEntry {
    static func yearSelectPredicate(yearSelection: String) -> Predicate<LogEntry> {
        let camperID = Defaults[.selectedCamperIDKey]
        let calendar = Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        if camperID == nil {
            return #Predicate<LogEntry> { _ in
                false  // don't find any trips
            }
        }
        
        if yearSelection == "All years" {
            return #Predicate<LogEntry> { trip in
                trip.camper.id == camperID!
            }
        }

        let year:Int = Int(yearSelection) ?? 2025

        let startOfYearComponents = DateComponents(
          calendar: calendar,
          year: year,
          month: 1,
          day: 1,
          hour: 0,
          minute: 00
        )
        let startOfYear = calendar.date(from: startOfYearComponents)!

        let endOfYearComponents = DateComponents(
          calendar: calendar,
          year: year,
          month: 12,
          day: 31,
          hour: 11,
          minute: 59
        )
        let endOfYear = calendar.date(from: endOfYearComponents)!

        return #Predicate<LogEntry> { trip in
            (trip.camper.id == camperID!) && (trip.startDate >= startOfYear && trip.startDate <= endOfYear)
        }
    }
}

