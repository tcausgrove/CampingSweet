//
//  LogBookView-ViewModel.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import Foundation

@MainActor class ViewModel: ObservableObject {
//    @Published private(set) var trips = [LogEntry]()
//    @Published private(set) var fuelings = [FuelEntry]()
    @Published private(set) var campers = [Camper]()
    @Published private(set) var settings = Settings.example
    
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedShoppingList")
    

    init() {
//        if let data = UserDefaults.standard.data(forKey: "trips") {
//            if let decoded = try? JSONDecoder().decode([LogEntry].self, from: data) {
//                trips = decoded
//            } else {
                // unable to get trips
//                print("Unable to get trips")
//                trips = []
//            }
//        }

//        if let data = UserDefaults.standard.data(forKey: "fuelings") {
//            if let decoded = try? JSONDecoder().decode([FuelEntry].self, from: data) {
//                fuelings = decoded
//                return
//            }
//        }
        // unable to get fuelings
//        fuelings = []

        if let data = UserDefaults.standard.data(forKey: "campers") {
            if let decoded = try? JSONDecoder().decode([Camper].self, from: data) {
                campers = decoded
            } else {
                // unable to get campers
                print("Unable to get campers")
                campers = []
            }
        }
        
        if let data = UserDefaults.standard.data(forKey: "settings") {
            if let decoded = try? JSONDecoder().decode(Settings.self, from: data) {
                settings = decoded
            } else {
                print("Unable to get settings")
                settings = Settings.example
            }
        }
    }
    
    func addTrip(newTrip: LogEntry) {
        if let theCamper = campers.first(where: { $0 == self.getCurrentCamper() }) {
            if let index = campers.firstIndex(of: theCamper) {
                var replacementCamper = campers[index]
                replacementCamper.trips.append(newTrip)
                campers[index] = replacementCamper
            }
        }
        save()
    }

//    func addFuelEntry(newFuelEntry: FuelEntry) {
//        fuelings.append(newFuelEntry)
//        save()
//    }
    
    func addNewCamper(newCamper: Camper) {
        campers.append(newCamper)
        setCurrentCamper(selectedCamperName: newCamper.name)
        save()
    }
    
    func getCurrentCamperID() -> UUID? {
        let theCamper = campers.first(where: { $0.isDefaultCamper == true }) ?? campers.first
        return theCamper?.id
    }
    
    func getCurrentCamper() -> Camper? {
        let theCamper = campers.first(where: { $0.isDefaultCamper == true })
        return theCamper
    }
    
    func getCurrentCamperName() -> String {
        let theCamper = campers.first(where: { $0.isDefaultCamper == true }) ?? campers.first
        return ( theCamper?.name ?? "" )
    }
    
    func setCurrentCamper(selectedCamperName: String) {
        //  First, set every camper to NOT be default
        for camper in campers {
            let replacementCamperIndex = campers.firstIndex(of: camper) ?? 0
            var replacementCamper = campers[replacementCamperIndex]
            replacementCamper.isDefaultCamper = false
            campers[replacementCamperIndex] = replacementCamper
        }

        // Then, set selected camper to be default
        if let theCamper = campers.first(where: { $0.name == selectedCamperName }) {
            if let index = campers.firstIndex(of: theCamper) {
                var replacementCamper = campers[index]
                replacementCamper.isDefaultCamper = true
                campers[index] = replacementCamper
            }
        }
        save()
    }

//    func getTripsForCamperByID(camperID: UUID) -> [LogEntry] {
//        var camperTrips: [LogEntry] = []
//        for trip in trips {
//            if trip.camperID == camperID { camperTrips.append(trip) }
//        }
//        return camperTrips
//    }
    
    func currentCamperExists() -> Bool {
        self.getCurrentCamper() != nil

    }
    
    func getDefaultNumberOfNights(trip: LogEntry) -> Int {
        return Int(trip.endDate - trip.startDate)
    }
    
    func deleteTrips(indexSet: IndexSet) {
        if let theCamper = campers.first(where: { $0 == self.getCurrentCamper() }) {
            if let index = campers.firstIndex(of: theCamper) {
                var replacementCamper = campers[index]
                for index in indexSet {
                    replacementCamper.trips.remove(at: index)
                    campers[index] = replacementCamper
                }
            }
            save()
        }
    }
    
//    func getTotalCurrentCamperMiles() -> String {
//        if self.currentCamperExists() {
//            let camperTrips = getTripsForCamperByID(camperID: self.getCurrentCamperID()!)
//            var totalMiles: Float = 0.0
//            for trip in camperTrips {
//                totalMiles += trip.distance ?? 0.0
//            }
//            let value = String(totalMiles.formatted(.number))
//            return value
//        } else {
//            return "0.0"
//        }
//    }
    
    func changeSettings(newChosenUnits: UnitOptions, newChosenDistance: DistanceOptions, newClockHours: ClockHours) {
        self.settings.chosenUnits = newChosenUnits
        self.settings.chosenDistance = newChosenDistance
        self.settings.chosenClockHours = newClockHours
        
        save()
    }
    
    func save() {
//        if let encoded = try? JSONEncoder().encode(trips) {
//            UserDefaults.standard.set(encoded, forKey: "trips")
//        }
        
//        if let encoded = try? JSONEncoder().encode(fuelings) {
//            UserDefaults.standard.set(encoded, forKey: "fuelings")
//        }
        
        if let encoded = try? JSONEncoder().encode(campers) {
            UserDefaults.standard.set(encoded, forKey: "campers")
        }
        
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: "settings")
        }
    }
}

