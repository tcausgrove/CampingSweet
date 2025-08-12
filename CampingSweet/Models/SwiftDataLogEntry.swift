//
//  SwiftDataLogEntry.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 6/19/25.
//

import SwiftUI
import SwiftData

@Model
class SwiftDataLogEntry {
    var title: String = ""
    var distance: Double?
    var startDate: Date
    var endDate: Date
    var latitude: Double?
    var longitude: Double?

    init(title: String, distance: Double? = nil, startDate: Date = Date(), endDate: Date = Date(), latitude: Double? = nil, longitude: Double? = nil) {
        self.title = title
        self.distance = distance
        self.startDate = startDate
        self.endDate = endDate
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var numberOfNights: Int {
        let number = ((endDate - startDate) / 24 / 3600).rounded()
        return Int(number)
    }
    
    var drivingDistanceMiles: Measurement<UnitLength>? {
            get {
                if let distance {
                    return Measurement<UnitLength>(value: distance, unit: .miles)
                } else { return nil }
            }
        set { distance = newValue?.converted(to: .miles).value }
    }

}
