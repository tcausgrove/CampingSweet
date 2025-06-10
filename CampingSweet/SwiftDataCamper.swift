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
    
    
    init(name: String = "Initial camper", isDefaultCamper: Bool = false, isArchived: Bool = false, registrationNumber: String = "") {
        self.name = name
        self.isDefaultCamper = isDefaultCamper
        self.isArchived = isArchived
        self.registrationNumber = registrationNumber
    }
}
