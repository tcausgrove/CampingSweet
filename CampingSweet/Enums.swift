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

enum DateFormatType: String, CaseIterable, Identifiable, Codable {
    case monthFirst = "MM/dd/yy"
    case dayFirst = "dd/MM/yy"
    
    var id: Self { self }
}

enum HelpFAQ: String, CaseIterable, Identifiable {
    case introQuestion = "Frequently Asked Questions"
    case logBookUnavailable = "Why is the log book unavailble?"
    case archiveCamper = "What is archiving a camper?"
    
    var id: Self { self }
}

//enum FAQAnswers: String, CaseIterable, Identifiable {
//    case introQuestion, logBookUnavailable, archiveCamper
//    var id: self { self }
//}

extension HelpFAQ {
    var faqAnswer: String {
        switch self {
        case .introQuestion: return ""
        case .logBookUnavailable: return "Probably no camper"
        case .archiveCamper: return "Gets it out of the way"
        }
    }
}
