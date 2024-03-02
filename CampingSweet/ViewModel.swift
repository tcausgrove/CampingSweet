//
//  LogBookView-ViewModel.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import Foundation

@MainActor class ViewModel: ObservableObject {
    @Published private(set) var trips = [LogEntry]()
    @Published private(set) var fuelings = [FuelEntry]()
    @Published private(set) var campers = [Camper]()
    @Published private(set) var settings = Settings.example
    
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedShoppingList")
    

    init() {
        if let data = UserDefaults.standard.data(forKey: "trips") {
            if let decoded = try? JSONDecoder().decode([LogEntry].self, from: data) {
                trips = decoded
                return
            }
        }
        // unable to get trips
        trips = []

        if let data = UserDefaults.standard.data(forKey: "fuelings") {
            if let decoded = try? JSONDecoder().decode([FuelEntry].self, from: data) {
                fuelings = decoded
                return
            }
        }
        // unable to get fuelings
        fuelings = []

        if let data = UserDefaults.standard.data(forKey: "campers") {
            if let decoded = try? JSONDecoder().decode([Camper].self, from: data) {
                campers = decoded
                return
            }
        }
        // unable to get campers
        campers = []
    }
    
    func addTrip(newTrip: LogEntry) {
        trips.append(newTrip)
        save()
    }
    
    func addFuelEntry(newFuelEntry: FuelEntry) {
        fuelings.append(newFuelEntry)
        save()
    }
    
    func addNewCamper(newVessel: Camper) {
        campers.append(newVessel)
        save()
    }
    
    func getCurrentCamper() -> Camper? {
        return campers.last
    }
    
    func currentCamperExists() -> Bool {
        self.getCurrentCamper() != nil

    }
    
    func changeSettings(newHomePort: String, newSelectedCamperID: UUID, newChosenUnits: UnitOptions, newChosenDistance: DistanceOptions, newClockHours: ClockHours) {
        self.settings.defaultHomePort = newHomePort
        self.settings.defaultCamperID = newSelectedCamperID
        self.settings.chosenUnits = newChosenUnits
        self.settings.chosenDistance = newChosenDistance
        self.settings.chosenClockHours = newClockHours
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: "trips")
        }
        
        if let encoded = try? JSONEncoder().encode(fuelings) {
            UserDefaults.standard.set(encoded, forKey: "fuelings")
        }
        
        if let encoded = try? JSONEncoder().encode(campers) {
            UserDefaults.standard.set(encoded, forKey: "campers")
        }
    }
}

