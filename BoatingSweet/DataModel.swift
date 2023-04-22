//
//  ViewModel.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import Foundation

struct LogEntry: Identifiable, Codable {
    var id: UUID
    var boat: String = ""
    var title: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    var distance: Float?
    
    var duration: TimeInterval {
        return endDate - startDate
    }
}

struct FuelEntry: Identifiable, Codable {
    var id: UUID
    var date: Date = Date()
    var boat: String = ""
    var engineHours: Float = 0.0
    var cost: Float = 0.0
    var volume: Float = 0.0
    
//    static let example = FuelEntry(id: UUID(), boat: "Our boat", engineHours: 189.0, cost: 45.0, volume: 12.345)
}

struct Boat: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var registrationNumber: String
    
    static let example = Boat(id: UUID(), name: "nano", registrationNumber: "TX12345")
}

struct Settings {
    var defaultHomePort: String
    var defaultBoatID: UUID
    var chosenUnits: UnitOptions
    var chosenDistance: DistanceOptions
    var chosenClockHours: ClockHours
    
    static let example = Settings(defaultHomePort: "None", defaultBoatID: UUID(), chosenUnits: .america, chosenDistance: .mi, chosenClockHours: .two)
}

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
