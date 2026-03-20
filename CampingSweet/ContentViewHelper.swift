//
//  ContentViewHelper.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 10/27/25.
//

import SwiftUI
import Defaults

enum ViewList: String, Codable, CaseIterable, Identifiable, Defaults.Serializable {
    var id: String { self.rawValue }
    
    case campers = "Campers"
    case logbook = "Log Book"
    case maps = "Maps"
    case charts = "Charts"
    case checklist = "Departure Checklist"
    case settings = "Settings"
    case help = "Help"
}

