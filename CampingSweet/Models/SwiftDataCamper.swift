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
    var trips: [SwiftDataLogEntry] = [SwiftDataLogEntry(title: "Trip 1", distance: 123.4),
                                  SwiftDataLogEntry(title: "Trip 2", distance: 234.5)]
    
    
    init(name: String = "Initial camper", isDefaultCamper: Bool = false, isArchived: Bool = false, registrationNumber: String = "") {
        self.name = name
        self.isDefaultCamper = isDefaultCamper
        self.isArchived = isArchived
        self.registrationNumber = registrationNumber
    }
    
    public static func selectedCamper(with modelContext: ModelContext) -> SwiftDataCamper {
        if let result = try! modelContext.fetch(FetchDescriptor<SwiftDataCamper>()).first(where: { $0.isDefaultCamper == true }) {
            return result
        } else {
            let newInstance = SwiftDataCamper(name: "Example Camper", isDefaultCamper: false, isArchived: false , registrationNumber: "")
            modelContext.insert(newInstance)
            return newInstance
        }
    }

    var totalCamperNights: Int {
        return 13
    }
    
    var totalCamperDistance: Double {
        return 123.4
    }
}
