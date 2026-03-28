//
//  SampleData+Camper.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 9/9/25.
//

import Foundation
import SwiftData
import Defaults

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
    
    static let tripA0 = LogEntry(title: "First A trip",
                                 distance: 12.3,
                                 startDate: Date(timeIntervalSince1970: 1652552800),
                                 endDate: Date(timeIntervalSince1970: 1652639200),
                                 latitude: 27.46665,
                                 longitude: -97.3,
                                 camper: previewCamperA)
    
    static let tripA1 = LogEntry(title: "Second A trip",
                                 distance: 45.6,
                                 startDate: Date(timeIntervalSinceNow: -86400 * 3),
                                 endDate: Date(timeIntervalSinceNow: -86400),
                                 latitude: 33.316667,
                                 longitude: -104.316666,
                                 camper: previewCamperA)
    
    static let tripB0 = LogEntry(title: "First B trip",
                                 distance: 78.9,
                                 startDate: Date(timeIntervalSince1970: 1688331600),
                                 endDate: Date(timeIntervalSince1970: 1688677200),
                                 latitude: 36.53333,
                                 longitude: -105.133334,
                                 camper: previewCamperB)
    
    static let tripB1 = LogEntry(title: "Second B trip",
                                 distance: 123.4,
                                 startDate: Date(timeIntervalSince1970: 1709824000),
                                 endDate: Date(timeIntervalSince1970: 1710555200),
                                 latitude: 34.53333,
                                 longitude: -100.0,
                                 camper: previewCamperB)
    
    static let archiveTrip0 = LogEntry(title: "Archive A",
                                       distance: 32.1,
                                       startDate: Date(timeIntervalSince1970: 1630_000_000),
                                       endDate: Date(timeIntervalSince1970: 1630_259_200),
                                       latitude: 38.0,
                                       longitude: -95.0,
                                       camper: archivedCamper)
    
    static let archiveTrip1 = LogEntry(title: "Archive B",
                                       distance: 123.4,
                                       startDate: Date(timeIntervalSince1970: 1680000000),
                                       endDate: Date(timeIntervalSince1970: 1680_259_200),
                                       latitude: 28.0,
                                       longitude: -80.0,
                                       camper: archivedCamper)
    
    static let item1 = CheckListItem(name: "Turn off propane", hasCheck: true)
    
    static func insertSampleData(modelContext: ModelContext) {
        // Add the checklist item
        modelContext.insert(item1)
        
        // Add the campers to the model context
        modelContext.insert(previewCamperA)
        modelContext.insert(previewCamperB)
        modelContext.insert(archivedCamper)
        
        modelContext.insert(tripA0)
        modelContext.insert(tripA1)
        modelContext.insert(tripB0)
        modelContext.insert(tripB1)
        modelContext.insert(archiveTrip0)
        modelContext.insert(archiveTrip1)
        
//        tripA0.camper = previewCamperA
//        tripA1.camper = previewCamperA
//        tripB0.camper = previewCamperB
//        tripB1.camper = previewCamperB
//        archiveTrip0.camper = archivedCamper
//        archiveTrip1.camper = archivedCamper
        
        previewCamperA.trips.append(tripA0)
        previewCamperA.trips.append(tripA1)
        previewCamperB.trips.append(tripB0)
        previewCamperB.trips.append(tripB1)
        archivedCamper.trips.append(archiveTrip0)
        archivedCamper.trips.append(archiveTrip1)        
    }
}
