//
//  Extensions.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 6/22/23.
//

import Foundation
import SwiftUI
import MapKit

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


extension Double {
    func decimalPlaces(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return ( self * divisor).rounded() / divisor
    }
}


extension CLLocationCoordinate2D {
    init(dmsString: String) {
        let scanner = Scanner(string: dmsString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "°'\" ")
        var decimalLatitude: Double = 0.0
        var decimalLongitude: Double = 0.0
        
        
        while
            let latDegrees = scanner.scanUpToString("°"),
            let latMinutes = scanner.scanUpToString("'"),
            let latSeconds = scanner.scanUpToString("\""),
            let latDirection = scanner.scanUpToString(" "),
            let lonDegrees = scanner.scanUpToString("°"),
            let lonMinutes = scanner.scanUpToString("'"),
            let lonSeconds = scanner.scanUpToString("\""),
            let lonDirection = scanner.scanUpToString("\n")
        {
            decimalLatitude = Double(latDegrees) ?? 0.0
            decimalLatitude += (Double(latMinutes) ?? 0.0) / 60.0
            decimalLatitude += (Double(latSeconds) ?? 0.0) / 3600.0
            
            decimalLongitude = Double(lonDegrees) ?? 0.0
            decimalLongitude += (Double(lonMinutes) ?? 0.0) / 60.0
            decimalLongitude += (Double(lonSeconds) ?? 0.0) / 3600.0
            
            if latDirection == "S" { decimalLatitude = decimalLatitude * -1.0}
            if lonDirection == "W" { decimalLongitude = decimalLongitude * -1.0}
            
            decimalLatitude = decimalLatitude.decimalPlaces(toPlaces: 6)
            decimalLongitude = decimalLongitude.decimalPlaces(toPlaces: 6)
        }
        
        self.init(latitude: decimalLatitude, longitude: decimalLongitude)
    }
}
