//
//  CheckListClass.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 5/22/25.
//

import Foundation
import SwiftData

@Model
class CheckListItem {
    var name: String
    var hasCheck: Bool
    
    init(name: String = "", hasCheck: Bool = false) {
        self.name = name
        self.hasCheck = hasCheck
    }
}
