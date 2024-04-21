//
//  Enums.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import Foundation

enum VolumeOptions: String, CaseIterable, Identifiable, Codable {
    case america = "Gallons"
    case europe = "Liters"

    var id: Self { self }
}

enum DistanceOptions: String, CaseIterable, Identifiable, Codable {
    case mi = "Miles"
    case km = "Kilometers"
    case nm = "Nautical miles"
    
    var id: Self { self }
}

enum ClockHours: String, CaseIterable, Identifiable, Codable {
    case two = "12 Hour"
    case one = "24 Hour"
    
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
