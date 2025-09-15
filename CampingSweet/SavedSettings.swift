//
//  TestDefault.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 9/15/25.
//  Based on https://fatbobman.com/en/posts/appstorage/
//

import SwiftUI
import SwiftData

public class SavedSettings: ObservableObject {
    @AppStorage("settingsTripFilter") var settingsTripFilter = FilterTrips.allTrips
    @AppStorage("settingsSelectedCamperID") var settingsSelectedCamperID: SwiftDataCamper.ID?
    public static let shared = SavedSettings()
}

@propertyWrapper
public struct AppSettings<T>: DynamicProperty {
    @ObservedObject private var defaults: SavedSettings
    private let keyPath: ReferenceWritableKeyPath<SavedSettings, T>
    public init(_ keyPath: ReferenceWritableKeyPath<SavedSettings, T>, defaults: SavedSettings = .shared) {
        self.keyPath = keyPath
        self.defaults = defaults
    }

    public var wrappedValue: T {
        get { defaults[keyPath: keyPath] }
        nonmutating set { defaults[keyPath: keyPath] = newValue }
    }

    public var projectedValue: Binding<T> {
        Binding(
            get: { defaults[keyPath: keyPath] },
            set: { value in
                defaults[keyPath: keyPath] = value
            }
        )
    }
}
