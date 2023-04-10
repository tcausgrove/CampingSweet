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
    
    init() {
//        trips.append(LogEntry.example)
//        fuelings.append(FuelEntry.example)
    }
    
    func addTrip(newTrip: LogEntry) {
        trips.append(newTrip)
    }
    
    func addFuelEntry(newFuelEntry: FuelEntry) {
        fuelings.append(newFuelEntry)
    }
    
    func addNewVessel(newVessel: Boat) {
        boats.append(newVessel)
    }
    
    func getCurrentBoat() -> Boat? {
        return boats.last
    }
    
    func currentBoatExists() -> Bool {
        self.getCurrentBoat() != nil

    }
}

