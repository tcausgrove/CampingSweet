//
//  LogBookView-ViewModel.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import Foundation

@MainActor class ViewModel: ObservableObject {
    @Published private(set) var campers = [Camper]()
    @Published private(set) var settings = Settings.example
    
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedShoppingList")
    

    init() {

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
    
    func addTrip(title: String, startDate: Date, endDate: Date, distance: String) {
        let tripID = UUID()
        let distanceDouble = Double(distance) ?? 0.0
        var tripInMiles: Measurement<UnitLength> = Measurement(value: 0.0, unit: UnitLength.meters)
        
        switch settings.chosenDistance {
        case .mi:
            tripInMiles = Measurement(value: distanceDouble, unit: UnitLength.miles)
        case .km:
            tripInMiles = Measurement(value: distanceDouble, unit: UnitLength.kilometers).converted(to: UnitLength.miles)
        case .nm:
            tripInMiles = Measurement(value: distanceDouble, unit: UnitLength.nauticalMiles).converted(to: UnitLength.miles)
        }
        let newTrip = LogEntry(id: tripID, title: title, startDate: startDate, endDate: endDate, distance: tripInMiles.value)

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
    
    func getCamperFormattedDistance(theCamper: Camper) -> String {
        var distance: String = ""
        
        if let theCamper = campers.first(where: { $0 == theCamper }) {
            
            let distanceInMiles = theCamper.totalCamperDistance
            distance = formatDistanceBySetting(distance: distanceInMiles)
        }
        return distance
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
    
    func changeSettings(newChosenUnits: UnitOptions, newChosenDistance: DistanceOptions, newClockHours: ClockHours) {
        self.settings.chosenUnits = newChosenUnits
        self.settings.chosenDistance = newChosenDistance
        self.settings.chosenClockHours = newClockHours
        
        save()
    }
    
    func save() {
        
        if let encoded = try? JSONEncoder().encode(campers) {
            UserDefaults.standard.set(encoded, forKey: "campers")
        }
        
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: "settings")
        }
    }
    
    func formatDistanceBySetting(distance: Double) -> String {
        
        var formattedDistance: Measurement<UnitLength> = Measurement(value: 0.0, unit: UnitLength.meters)
        
        switch settings.chosenDistance {
        case .mi:
            formattedDistance = Measurement(value: distance, unit: UnitLength.miles)
        case .km:
            formattedDistance = Measurement(value: distance, unit: UnitLength.miles).converted(to: UnitLength.kilometers)
        case .nm:
            formattedDistance = Measurement(value: distance, unit: UnitLength.miles).converted(to: UnitLength.nauticalMiles)
        }
        return formattedDistance.formatted()
    }
}

