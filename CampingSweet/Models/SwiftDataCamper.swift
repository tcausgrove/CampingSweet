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
    var name: String
    var isDefaultCamper: Bool
    var isArchived: Bool
    var registrationNumber: String
    var trips: [SwiftDataLogEntry]
    
    
    init(name: String = "Initial camper", isDefaultCamper: Bool = false, isArchived: Bool = false, registrationNumber: String = "", trips: [SwiftDataLogEntry] = []) {
        self.name = name
        self.isDefaultCamper = isDefaultCamper
        self.isArchived = isArchived
        self.registrationNumber = registrationNumber
        self.trips = trips
    }
    
    public static func selectedCamper(with modelContext: ModelContext) -> SwiftDataCamper {
        if let result = try! modelContext.fetch(FetchDescriptor<SwiftDataCamper>()).first(where: { $0.isDefaultCamper == true }) {
            return result
        } else {
            let newInstance = SwiftDataCamper(name: "Example Camper", isDefaultCamper: true, isArchived: false , registrationNumber: "")
            modelContext.insert(newInstance)
            return newInstance
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
