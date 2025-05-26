//
//  ViewModel.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 4/10/23.
//

import Foundation

@MainActor class ViewModel: ObservableObject {
    @Published private(set) var campers = [Camper]()
    @Published private(set) var settings = Settings.example
    @Published var userError: UserError? = nil
    
    init() {

        if let data = UserDefaults.standard.data(forKey: "campers") {
            if let decoded = try? JSONDecoder().decode([Camper].self, from: data) {
                campers = decoded
                userError = nil
            } else {
                // unable to get campers
                campers = []
                userError = UserError.failedLoading
            }
        }
        
        if let data = UserDefaults.standard.data(forKey: "settings") {
            if let decoded = try? JSONDecoder().decode(Settings.self, from: data) {
                settings = decoded
                userError = nil
            } else {
                settings = Settings.example
                userError = UserError.settingsNotFound
            }
        }
    }
    
    func addTrip(title: String, startDate: Date, endDate: Date, distance: String, latitude: String, longitude: String) {
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
        let newTrip = LogEntry(id: tripID,
                               title: title,
                               startDate: startDate,
                               endDate: endDate,
                               distance: tripInMiles.value,
                               latitude: Double(latitude),
                               longitude: Double(longitude) )

        if let theCamper = campers.first(where: { $0 == self.getCurrentCamper() }) {
            if let index = campers.firstIndex(of: theCamper) {
                var replacementCamper = campers[index]
                replacementCamper.trips.append(newTrip)
                campers[index] = replacementCamper
            }
        }
        save()
    }
    
    func editTrip(tripID: UUID, title: String, startDate: Date, endDate: Date, distance: String, latitude: String?, longitude: String?) {
        let distanceDouble = Double(distance) ?? 0.0
        let tripInMiles: Measurement<UnitLength> = Measurement(value: distanceDouble, unit: UnitLength.meters)
        
        if let theCamper = campers.first(where: { $0 == self.getCurrentCamper() }) {
            let theCamperIndex = campers.firstIndex(of: theCamper)
            //FIXME: There must be a better way to do the stuff below
            if let tripIndex = theCamper.trips.firstIndex(where: { $0.id == tripID }) {
                campers[theCamperIndex!].trips[tripIndex].title = title
                campers[theCamperIndex!].trips[tripIndex].startDate = startDate
                campers[theCamperIndex!].trips[tripIndex].endDate = endDate
                campers[theCamperIndex!].trips[tripIndex].distance = tripInMiles.value
                if latitude != nil { campers[theCamperIndex!].trips[tripIndex].latitude = Double(latitude!) }
                if longitude != nil { campers[theCamperIndex!].trips[tripIndex].longitude = Double(longitude!) }
            } else {
                userError = .tripDoesNotExist
            }
        }
    }
    
    func deleteTrip(tripID: UUID) {
        if let theCamper = campers.first(where: { $0 == self.getCurrentCamper() }) {
            if let theTrip = theCamper.trips.first(where: { $0.id == tripID }) {
                if let index = theCamper.trips.firstIndex(of: theTrip) {
                    self.campers[campers.firstIndex(of: theCamper)!].trips.remove(at: index)
                }
            }
        }
    }
    
    func addImportedTrips(newTrips: [LogEntry]) {
        if let theCamper = campers.first(where: { $0 == self.getCurrentCamper() }) {
            if let index = campers.firstIndex(of: theCamper) {
                var replacementCamper = campers[index]
                for trip in newTrips {
                    replacementCamper.trips.append(trip)
                }
                campers[index] = replacementCamper
            }
        } else {
            // FIXME:  Need an error option for bad CSV file import
            userError = .failedSaving
        }
        save()

    }
  
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
    
    func deleteCamper(camperToDelete: Camper) {
        if let theCamper = campers.first(where: { $0 == camperToDelete }) {
            if let index = campers.firstIndex(of: theCamper) {
                self.campers.remove(at: index)
            }
            if !currentCamperExists() {
                setCurrentCamperToFirst()
            }
            save()
        }
    }
    
    func toggleCamperArchival(camperToArchive: Camper) {
        if let replacementCamperIndex = campers.firstIndex(of: camperToArchive) {
            var replacementCamper = campers[replacementCamperIndex]
            replacementCamper.isArchived.toggle()
            replacementCamper.isDefaultCamper = false
            campers[replacementCamperIndex] = replacementCamper
        }
        if !currentCamperExists() {
            setCurrentCamperToFirst()
        }
        save()
   }
    
    func setDisplayedNightsText(start: Date, end: Date) -> String {
        let numberOfNigts = Int( ((end - start) / 24 / 3600).rounded() )
        return ("Number of nights: \(numberOfNigts)")
    }

    func deleteTrips(indexSet: IndexSet) {
        if let theCamper = campers.first(where: { $0 == self.getCurrentCamper() }) {
            if let index = campers.firstIndex(of: theCamper) {
                var replacementCamper = campers[index]
                for tripIndex in indexSet {
                    replacementCamper.trips.remove(at: tripIndex)
                    campers[index] = replacementCamper
                }
            }
            save()
        }
    }
    
    func save() {
        
        do {
            let encodedCampers = try JSONEncoder().encode(campers)
            UserDefaults.standard.set(encodedCampers, forKey: "campers")
            userError = nil
        } catch {
            userError = UserError.failedSaving
        }
        
        do {
            let encodedSettings = try JSONEncoder().encode(settings)
            UserDefaults.standard.set(encodedSettings, forKey: "settings")
            userError = nil
        } catch {
            userError = UserError.settingsNotFound
        }
}
    
    func convertDoubleBySetting(distance: Double) -> Measurement<UnitLength> {
        var formattedDistance: Measurement<UnitLength> = Measurement(value: 0.0, unit: UnitLength.meters)

        switch settings.chosenDistance {
        case .mi:
            formattedDistance = Measurement(value: distance, unit: UnitLength.miles)
        case .km:
            formattedDistance = Measurement(value: distance, unit: UnitLength.miles).converted(to: UnitLength.kilometers)
        case .nm:
            formattedDistance = Measurement(value: distance, unit: UnitLength.miles).converted(to: UnitLength.nauticalMiles)
        }
        return formattedDistance
    }
    
    func formatDistanceBySetting(distance: Double) -> String {
        let formattedDistance = convertDoubleBySetting(distance: distance)
        let unitFormatter = UnitFormatter()
        
        return unitFormatter.formatter.string(from: formattedDistance)
    }
    
    func getDistanceUnitFromSetting() -> String {
        let arbitraryNumber = 12.3
        let formattedDistance = convertDoubleBySetting(distance: arbitraryNumber)
        let unitFormatter = UnitFormatter()
        
        let unit = unitFormatter.formatter.string(from: formattedDistance.unit)
        
        return unit
    }
    
    func hasArchivedCampers() -> Bool {
        var returnValue = false
        for camper in campers {
            if camper.isArchived { returnValue = true }
        }
        return returnValue
    }
    
    func setCurrentCamperToFirst() {
        // Set all campers so they are not the selected one
        for camper in campers {
            if let index = campers.firstIndex(of: camper) {
                var replacementCamper = camper
                replacementCamper.isDefaultCamper = false
                campers[index] = replacementCamper
            }
            // Set camper with index = 0 to the selected one
            if campers.count != 0 {
                var replacementCamper = campers[0]
                replacementCamper.isDefaultCamper = true
                campers[0] = replacementCamper
            } else {
                print("Why am I here?")
                // There are no campers; the camper log page won't be available
            }
        }
    }
}

