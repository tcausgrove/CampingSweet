//
//  Extensions.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 6/22/23.
//

import Foundation
import SwiftUI

extension View {
    func numbersOnly(_ text: Binding<String>, includeDecimal: Bool = false) -> some View {
        self.modifier(NumbersOnlyViewModifier(text: text, includeDecimal: includeDecimal))
    }
}

extension TimeInterval {
    func customTimeFormat(using units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropLeading

        return formatter.string(from: self)
    }
}

struct UnitFormatter {
    let formatter = MeasurementFormatter()
    
    init() {
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .long
        formatter.numberFormatter.generatesDecimalNumbers = true
        formatter.numberFormatter.maximumFractionDigits = 1
    }
}
