//
//  NavigationManager.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 10/25/25.
//

import SwiftUI

@Observable
class NavigationManager {
    var path = NavigationPath() {
        didSet {
            save()
//            print("Saved path")
        }
    }
    
    /// The URL for the JSON file that stores the navigation path.
    private static var dataURL: URL {
        .documentsDirectory.appending(path: "NavigationPath.json")
    }
    
    init() {
        do {
//            print("Initializing")
            // Load the data model from the 'NavigationPath' data file found in the Documents directory.
            let path = try load()
            self.path = path
        } catch {
//            print("Unable to initialize")
            // Handle error
        }
    }
    
    func save() {
//        print("Starting save")
        guard let codableRepresentation = path.codable else { return }
        let encoder = JSONEncoder()
        do {
//            print("setting data")
            let data = try encoder.encode(codableRepresentation)
            try data.write(to: NavigationManager.dataURL)
        } catch {
            //Handle error.
//            print("Unable to save")
        }
    }
    
    /// Load the navigation path from a previously saved data.
    func load() throws -> NavigationPath {
        let url = NavigationManager.dataURL
//        print(url)
        let data = try Data(contentsOf: url, options: .mappedIfSafe)
        let decoder = JSONDecoder()
        let path = try decoder.decode(NavigationPath.CodableRepresentation.self, from: data)
//        print(path)
//        print("Loaded path")
        return NavigationPath(path)
    }
}

