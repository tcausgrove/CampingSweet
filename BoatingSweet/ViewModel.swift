//
//  LogBookView-ViewModel.swift
//  BoatingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import Foundation

@MainActor class ViewModel: ObservableObject {
    @Published private(set) var trips = [LogEntry]()
    @Published private(set) var fuelings = [FuelEntry]()
    @Published private(set) var boats = [Boat]()
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

        if let data = UserDefaults.standard.data(forKey: "boats") {
            if let decoded = try? JSONDecoder().decode([Boat].self, from: data) {
                boats = decoded
                return
            }
        }
        // unable to get boats
        boats = []
    }
    
    func addTrip(newTrip: LogEntry) {
        trips.append(newTrip)
        save()
    }
    
    func addFuelEntry(newFuelEntry: FuelEntry) {
        fuelings.append(newFuelEntry)
        save()
    }
    
    func addNewVessel(newVessel: Boat) {
        boats.append(newVessel)
        save()
    }
    
    func getCurrentBoat() -> Boat? {
        return boats.last
    }
    
    func currentBoatExists() -> Bool {
        self.getCurrentBoat() != nil

    }
    
    func changeSettings(newHomePort: String, newSelectedBoatID: UUID, newChosenUnits: UnitOptions, newChosenDistance: DistanceOptions, newClockHours: ClockHours) {
        self.settings.defaultHomePort = newHomePort
        self.settings.defaultBoatID = newSelectedBoatID
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
        
        if let encoded = try? JSONEncoder().encode(boats) {
            UserDefaults.standard.set(encoded, forKey: "boats")
        }
    }
}

