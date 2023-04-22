//
//  Enums.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/19/23.
//

import Foundation

enum UnitOptions: String, CaseIterable, Identifiable {
    case europe = "Imperial"
    case america = "English"
    
    var id: Self { self }
}

enum DistanceOptions: String, CaseIterable, Identifiable {
    case mi = "Miles"
    case km = "Kilometers"
    case nm = "Nautical miles"
    
    var id: Self { self }
}

enum ClockHours: String, CaseIterable, Identifiable {
    case two = "12 Hour"
    case one = "24 Hour"
    
    var id: Self { self }
}
