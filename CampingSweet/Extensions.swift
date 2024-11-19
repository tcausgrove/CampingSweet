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

// Not currently used
struct SheetButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 44)
//            .background(Color.secondary) // change to light gray
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension Button {
    func sheetButtonStyle() -> some View {
        self
            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 44)
            .background(Color.sheetButtonBackground) // change to light gray
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension Date {
    
    var yesterday: Date {
       return Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
    }
    
    var tomorrow: Date {
       return Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!
    }
    
    func toString(format: String) -> String {   // sample usage: someDate.toString(format: "MMM d, yyyy") yields "Oct 7, 2023"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
