//
//  MapsView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 12/17/25.
//

import SwiftUI
import SwiftData
import MapKit
import Defaults

struct LowerMapView: View {
//    var camperName = ""
    @Environment(\.modelContext) private var modelContext
    @State private var position: MapCameraPosition = .camera(
        .init(centerCoordinate: .init(latitude: 37.7749, longitude: -122.4194), distance: 0) // Default values are in San Francisco
    )
    
    @Default(.selectedCamperIDKey) var selectedCamperID
    
    @Query var trips: [LogEntry]
    
    init(yearSelection: String, camperName: String) {
//        self.camperName = camperName
        let mapsPredicate = LogEntry.mapsPredicate(yearSelection: yearSelection, camperID: selectedCamperID)
        _trips = Query(filter: mapsPredicate, sort: \LogEntry.startDate)
    }
    
    var body: some View {
        let centerCoordinate = logEntryArrayToRegion(sites: trips)
        let camperName: String = Camper.selectedCamperFromID(with: modelContext,
                                                             selectedCamperID: selectedCamperID)?.name ?? "Unknown camper"
        if centerCoordinate == nil {
            Text("There are no log entries with location data for \(camperName) in the given time period.")
                .padding([.leading, .trailing], 32)
        } else {
            Map(position: $position, interactionModes: [.pan, .zoom]) {
                ForEach(trips) { trip in
                    if trip.hasLocationData {
                        Marker(trip.title, coordinate: trip.location!)
                    }
                }
            }
            .onAppear {
                position = .region(centerCoordinate ?? .init(center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.583), latitudinalMeters: 10000, longitudinalMeters: 10000))
            }
            .mapStyle(.standard(
                elevation: .realistic,
                emphasis: .automatic,
                pointsOfInterest: .excludingAll)
            )
            .padding(8)
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        LowerMapView(yearSelection: "2023", camperName: Camper.previewCamperA.name)
    }
}


func logEntryArrayToRegion(sites: [LogEntry]) -> MKCoordinateRegion? {
    var averageLatitude: Double = 0.0
    var averageLongitude: Double = 0.0
    var minLatitude: CLLocationDistance = 90.0
    var maxLatitude: CLLocationDistance = -90.0
    var minLongitude: CLLocationDistance = 180.0
    var maxLongitude: CLLocationDistance = -180.0
    var count: Int = 0
    
    for site in sites {
        if site.hasLocationData {
            if site.latitude! < minLatitude {
                minLatitude = site.latitude!
            }
            if site.longitude! < minLongitude {
                minLongitude = site.longitude!
            }
            
            if site.latitude! > maxLatitude {
                maxLatitude = site.latitude!
            }
            if site.longitude! > maxLongitude {
                maxLongitude = site.longitude!
            }
            averageLatitude += site.latitude!
            averageLongitude += site.longitude!
            count += 1
        }
    }
    if count != 0 {
        averageLatitude = averageLatitude / Double(count)
        averageLongitude = averageLongitude / Double(count)
    } else {
        return nil
    }
    
    let mapWidth = (maxLatitude - minLatitude) * 111320  // Approximate number of meters per degree
    let mapHeight = (maxLongitude - minLongitude) * 111320
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude), latitudinalMeters: mapWidth, longitudinalMeters: mapHeight)
    return (region)
}
