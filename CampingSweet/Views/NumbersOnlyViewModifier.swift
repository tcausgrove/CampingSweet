//
//  NumbersOnlyViewModifier.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 6/22/23.
//

import Foundation
import SwiftUI
import Combine


struct NumbersOnlyViewModifier: ViewModifier {
    
    @Binding var text: String
    var includeDecimal: Bool
    var includeNegative: Bool
    var digitAllowedAfterDecimal: Int
    
    func body(content: Content) -> some View {
        content
        //  Decided to control keyboard type separately
//            .keyboardType(includeDecimal ? .decimalPad : .numberPad)
//            .keyboardType(includeNegative ? .numbersAndPunctuation : .decimalPad)
            .onReceive(Just(text)) { newValue in
                if ( newValue == "" && text != "") { return } // This happens on the first read; allow display of text
                var numbers = "0123456789"
                let decimalSeparator: String = Locale.current.decimalSeparator ?? "."
                if includeDecimal {
                    numbers += decimalSeparator
                }
                if includeNegative {
                    numbers+="-"
                }
                if newValue.components(separatedBy: decimalSeparator).count-1 > 1 {
                    let filtered = newValue
                    self.text = isValid(newValue: String(filtered.dropLast()), decimalSeparator: decimalSeparator)
                } else {
                    let filtered = newValue.filter { numbers.contains($0)}
                    if filtered != newValue {
                        self.text = isValid(newValue: filtered, decimalSeparator: decimalSeparator)
                    } else {
                        self.text = isValid(newValue: newValue, decimalSeparator: decimalSeparator)
                    }
                }
            }
    }
    
    private func isValid(newValue: String, decimalSeparator: String) -> String {
        guard includeDecimal, !text.isEmpty else { return newValue }
        let component = newValue.components(separatedBy: decimalSeparator)
        if component.count > 1 {
            guard let last = component.last else { return newValue }
            if last.count > digitAllowedAfterDecimal {
                let filtered = newValue
               return String(filtered.dropLast())
            }
        }
        return newValue
    }
}
