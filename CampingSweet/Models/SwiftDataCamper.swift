//
//  SwiftDataCamper.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 5/26/25.
//

import Foundation
import SwiftData

@Model
class SwiftDataCamper {
    var id: UUID
    @Attribute(.unique) var name: String
    var isArchived: Bool
    var registrationNumber: String
    @Relationship(deleteRule: .cascade, inverse: \SwiftDataLogEntry.camper)
    var trips: [SwiftDataLogEntry]
        
    init(id: UUID, name: String = "Initial camper", isArchived: Bool = false, registrationNumber: String = "", trips: [SwiftDataLogEntry] = []) {
        self.id = id
        self.name = name
        self.isArchived = isArchived
        self.registrationNumber = registrationNumber
        self.trips = trips
    }
    
    static let example = SwiftDataCamper(id: UUID(), name: "Example camper", isArchived: false, registrationNumber: "Some reg number", trips: [])
    
// Should return nil when selectedCamperName is empty string
    public static func selectedCamperFromName(with modelContext: ModelContext, selectedCamperName: String) -> SwiftDataCamper? {
        if let result = try! modelContext.fetch(FetchDescriptor<SwiftDataCamper>()).first(where: { $0.name == selectedCamperName }) {
            return result
        } else {
            print("This really shouldn't happen")
            return nil
        }
    }
    
    public static func selectedCamperFromID(with modelContext: ModelContext, selectedCamperID: SwiftDataCamper.ID?) -> SwiftDataCamper? {
        if let result = try! modelContext.fetch(FetchDescriptor<SwiftDataCamper>()).first(where: { $0.id == selectedCamperID}) {
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
}

// A convenience for accessing a camper in an array by its identifier.
// Usage:  e.g., SwiftDataCamper[selectedId]?.name
// Not currently in use; not storing the selected camper ID
extension Array where Element: SwiftDataCamper {
    /// Gets the first camper in the array with the specified ID, if any.
    subscript(id: SwiftDataCamper.ID?) -> SwiftDataCamper? {
        first { $0.id == id }
    }
    
}

// Ensure that the model's conformance to Identifiable is public.
extension SwiftDataCamper: Identifiable {}
