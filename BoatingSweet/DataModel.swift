//
//  ViewModel.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import Foundation

struct LogEntry: Identifiable {
    var id: UUID
    var boat: String = ""
    var title: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    var distance: Float?
    
    var duration: TimeInterval {
        return endDate - startDate
    }
       
//    static let example = LogEntry(id: UUID(), title: "CC Bay")
}

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

struct FuelEntry: Identifiable {
    var id: UUID
    var date: Date = Date()
    var boat: String = ""
    var engineHours: Float = 0.0
    var cost: Float = 0.0
    var volume: Float = 0.0
    
//    static let example = FuelEntry(id: UUID(), boat: "Our boat", engineHours: 189.0, cost: 45.0, volume: 12.345)
}

struct Boat: Identifiable, Hashable {
    var id: UUID
    var name: String
    var registrationNumber: String
}

struct Settings {
    var defaultHomePort: String
    var defaultBoatID: UUID
    var chosenUnits: UnitOptions
    var chosen
}
