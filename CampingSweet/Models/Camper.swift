//
//  Camper.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 5/26/25.
//

import Foundation
import SwiftData

@Model
class Camper {
    var id: UUID
    @Attribute(.unique) var name: String
    var isArchived: Bool
    var registrationNumber: String
    @Relationship(deleteRule: .cascade, inverse: \LogEntry.camper)
    var trips: [LogEntry]
        
    init(id: UUID, name: String = "Initial camper", isArchived: Bool = false, registrationNumber: String = "", trips: [LogEntry] = []) {
        self.id = id
        self.name = name
        self.isArchived = isArchived
        self.registrationNumber = registrationNumber
        self.trips = trips
    }
    
    var idString: String {
        get { id.uuidString }
        set { id = UUID(uuidString: newValue)!
        }
    }
    
    static let example = Camper(id: UUID(), name: "Example camper", isArchived: false, registrationNumber: "Some reg number", trips: [])
    
// Should return nil when selectedCamperName is empty string
    public static func selectedCamperFromName(with modelContext: ModelContext, selectedCamperName: String) -> Camper? {
        if let result = try! modelContext.fetch(FetchDescriptor<Camper>()).first(where: { $0.name == selectedCamperName }) {
            return result
        } else {
            return nil
        }
    }
    
    public static func selectedCamperFromID(with modelContext: ModelContext, selectedCamperID: Camper.ID?) -> Camper? {
        if let result = try! modelContext.fetch(FetchDescriptor<Camper>()).first(where: { $0.id.matches(selectedCamperID)}) {
            return result
        } else {
            return nil
        }
    }

    var totalCamperNights: Int {
        var tempNights: Int = 0
        for trip in trips {
            tempNights += trip.numberOfNights
        }
        return tempNights
    }
    
    var totalCamperDistance: Double {
        var tempDistance = 0.0
        for trip in trips {
            let tripDistance = trip.distance ?? 0.0
            tempDistance = tempDistance + tripDistance
        }
        return tempDistance
    }
    
    var yearsUsed: [String] {
        var yearList: [String] = ["All years"]
        for trip in trips {
            let year: String = String(Calendar.current.component(.year, from: trip.startDate))
            if !yearList.contains(year) {
                yearList.append(year)
            }
        }
        return yearList.sorted()

    }
}

// A convenience for accessing a camper in an array by its identifier.
// Usage:  e.g., Camper[selectedId]?.name
// Not currently in use; not storing the selected camper ID
extension Array where Element: Camper {
    /// Gets the first camper in the array with the specified ID, if any.
    subscript(id: Camper.ID?) -> Camper? {
        first { $0.id == id }
    }
    
}

// Ensure that the model's conformance to Identifiable is public.
extension Camper: Identifiable {}
