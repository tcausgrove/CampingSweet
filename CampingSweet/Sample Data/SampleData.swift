//
//  SampleData+Camper.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 9/9/25.
//

import Foundation
import SwiftData

extension Camper {
    static let previewCamperA = Camper(id: UUID(),
                                                name: "Preview Camper A",
                                                isArchived: false,
                                                registrationNumber: "TX 12345",
                                                trips: [])
    
    static let previewCamperB = Camper(id: UUID(),
                                                name: "Preview Camper B",
                                                isArchived: false,
                                                registrationNumber: "TX 67890",
                                                trips: [])
    
    static let archivedCamper = Camper(id: UUID(),
                                                name: "Archived Camper",
                                                isArchived: true,
                                                registrationNumber: "TX 11111",
                                                trips: [])
    
    static let tripsA = [LogEntry(title: "First A trip",
                                          distance: 12.3,
                                          latitude: 27.46665,
                                          longitude: -97.3,
                                          camper: previewCamperA),
                         LogEntry(title: "Second A trip",
                                           distance: 45.6,
                                           latitude: 33.316667,
                                           longitude: -104.316666,
                                           camper: previewCamperA)]
    
    static let tripsB = [LogEntry(title: "First B trip",
                                           distance: 78.9,
                                           latitude: 36.53333,
                                           longitude: -105.133334,
                                           camper: previewCamperB)]
    
    static func insertSampleData(modelContext: ModelContext) {
        // Add the campers to the model context
        modelContext.insert(previewCamperA)
        modelContext.insert(previewCamperB)
        modelContext.insert(archivedCamper)
        
        previewCamperA.trips.append(contentsOf: tripsA)
        previewCamperB.trips.append(contentsOf: tripsB)
    }
}
