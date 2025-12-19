//
//  LogEntry.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 6/19/25.
//

import SwiftUI
import SwiftData
import CoreLocation

@Model
class LogEntry {
    var title: String = ""
    var distance: Double?
    var startDate: Date
    var endDate: Date
    var latitude: Double?
    var longitude: Double?
    
    @Relationship var camper: Camper?
    
    init(title: String,
         distance: Double? = nil,
         startDate: Date = Date(),
         endDate: Date = Date(),
         location: CLLocationCoordinate2D? = nil,
         latitude: Double? = nil,
         longitude: Double? = nil,
         camper: Camper? = nil)
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
    
    var drivingDistanceMiles: Measurement<UnitLength>? {
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
    static func predicate(searchText: String, datesToShow: FilterTrips, camperID: UUID) -> Predicate<LogEntry> {
        let nowDate = Date.now
        let calendar = Calendar(identifier: .gregorian)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: nowDate)
        
        let startOfYearComponents = DateComponents(
            calendar: calendar,
            year: Int(yearString),
            month: 1,
            day: 1,
            hour: 0,
            minute: 00
        )
        let startOfYear = calendar.date(from: startOfYearComponents)!
        
        if datesToShow == .currentYear {
            return #Predicate<LogEntry> { trip in
                // Need to used a closed range of dates
                return (trip.camper?.id == camperID) && (trip.startDate >= startOfYear && trip.startDate <= nowDate)
            }
        } else {
            return #Predicate<LogEntry> { trip in
                trip.camper?.id == camperID
            }
        }
    }
}


extension LogEntry {
    static func mapsPredicate(yearSelection: String, camperID: UUID?) -> Predicate<LogEntry> {
        let calendar = Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        if camperID == nil {
            return #Predicate<LogEntry> { trip in
                trip.camper?.id == camperID
            }
        }
        
        if yearSelection == "All years" {
            return #Predicate<LogEntry> { trip in
                trip.camper?.id == camperID
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
            (trip.camper?.id == camperID) && (trip.startDate >= startOfYear && trip.startDate <= endOfYear)
        }
    }
}

