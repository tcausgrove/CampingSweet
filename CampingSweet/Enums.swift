//
//  Enums.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import Foundation
import Defaults

enum DistanceOptions: String, CaseIterable, Identifiable, Codable {
    case mi = "Miles"
    case km = "Kilometers"
    case nm = "Nautical miles"
    
    var id: Self { self }
    
    var unit: UnitLength {
        switch self {
        case .mi: return .miles
        case .km: return .kilometers
        case .nm: return .nauticalMiles
        }
    }
}

enum TripDisplayType: String, CaseIterable, Identifiable, Codable {
    case card = "Card"
    case list = "List"
    
    var id: Self { self }
}

enum DateFormatType: String, CaseIterable, Identifiable, Codable {
    case monthFirst = "MM/dd/yy"
    case dayFirst = "dd/MM/yy"
    
    var id: Self { self }
}

enum LocationImportFormat: String, CaseIterable, Identifiable, Codable {
    case dd = "Decimal degrees"
    case dms = "Degrees minutes seconds"
    
    var id: Self { self }
}

enum DateImportFormat: String, CaseIterable, Identifiable, Codable {
    case startEnd = "Start and end dates"
    case startOnly = "Start date/#nights"

    var id: Self { self }
}

enum CamperType: String, CaseIterable, Identifiable {
    case traveltrailer = "Travel Trailer"
    case smallcamper = "Small Camper"
    case toyhauler = "Toy Hauler"
    case fifthwheel = "Fifth Wheel"
    case popup = "Pop Up"
    case classa = "Class A"
    case classb = "Class B"
    case classc = "Class C"
    
    var id: Self { self }
}

enum UserError: LocalizedError {
    case failedLoading
    case failedSaving
    case tripDoesNotExist
    case settingsNotFound
    case couldNotSaveCSV
    case camperNotFound
    case exportCSVSucceeded // Not really an error, but I want the dialog
    case importCSVSucceeded // Not really an error, but I want the dialog
    
    var errorDescription: String? {    // This shows up as the first thing in bold in the error alert
        switch self {
        case .exportCSVSucceeded: return "File saved"
        case .importCSVSucceeded: return "File loaded"
        default: return "Data error"
        }
    }
    
    var errorMessage: String? {    // This shows up as the second thing in smaller text in the error alert
        switch self {
        case .failedLoading: return "Unable to load the data"
        case .failedSaving: return "Unable to save the data"
        case .tripDoesNotExist: return "Unable to save changes; can't find this trip"
        case .settingsNotFound: return "Unable to find saved settings"
        case .couldNotSaveCSV: return "Unable to save CSV file"
        case .camperNotFound: return "Could not find a camper with that ID"
        case .exportCSVSucceeded: return "CSV file saved successfully"
        case .importCSVSucceeded: return "CSV file loaded successfully"
        }
    }
}

// This is currently unused
enum ArchivalAction: String, CaseIterable, Identifiable {
    case archive = "Archive"
    case unarchive = "Unarchive"
    
    var id: Self { self }
}

enum HelpSection: String, CaseIterable, Identifiable {
    case camperScreen = "Campers"
    case logBookScreen = "Log Book"
    case settingsScreen = "Settings"
    
    var id: Self { self }
}

enum FilterTrips: String, CaseIterable, Identifiable, Defaults.Serializable {
    case currentYear = "Current year only"
    case allTrips = "All trips"
    
    var id: Self { self }
}

