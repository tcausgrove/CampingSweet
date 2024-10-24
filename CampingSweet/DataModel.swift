//
//  ViewModel.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import Foundation

struct LogEntry: Identifiable, Hashable, Codable {
    var id: UUID
//    var camperID: UUID
    var title: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    // The stored distance will be in miles, using conversions to and from for display
    var distance: Double?
    
    var numberOfNights: Int {
        let number = ((endDate - startDate) / 24 / 3600).rounded()
        return Int(number)
    }
    
    static let example = LogEntry(id: UUID(), title: "Cimarron trip", startDate: Date.now, endDate: Date.now, distance: 123.4)
}

//struct FuelEntry: Identifiable, Codable {
//    var id: UUID
//    var date: Date = Date()
//    var camper: String = ""
//    var engineHours: Float = 0.0
//    var cost: Float = 0.0
//    var volume: Float = 0.0
    
//    static let example = FuelEntry(id: UUID(), boat: "Our boat", engineHours: 189.0, cost: 45.0, volume: 12.345)
//}

struct Camper: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var isDefaultCamper: Bool
    var registrationNumber: String
    var trips: [LogEntry]
    
    var totalCamperDistance: Double {    //  This will be in miles
//        let zeroDistance = Measurement(value: 0.0, unit: UnitLength.meters)
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
    
    static let example = Camper(id: UUID(), name: "nano", isDefaultCamper: false, registrationNumber: "TX12345", trips: [LogEntry.example])
}

struct Settings: Codable {
    var chosenUnits: VolumeOptions
    var chosenDistance: DistanceOptions
    var chosenClockHours: ClockHours
    
    static let example = Settings(chosenUnits: .america, chosenDistance: .mi, chosenClockHours: .two)
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

struct ChecklistItem: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var hasCheck: Bool
    
    static let example = ChecklistItem(id: UUID(), name: "More food", hasCheck: false)
}


