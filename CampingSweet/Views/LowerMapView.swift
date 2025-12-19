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
    @Default(.selectedCamperIDKey) var selectedCamperID
    
    @Query var trips: [LogEntry]
    
    init(yearSelection: String) {
        let mapsPredicate = LogEntry.mapsPredicate(yearSelection: yearSelection, camperID: selectedCamperID)
        _trips = Query(filter: mapsPredicate, sort: \LogEntry.startDate)
    }
    
    var body: some View {
        let centerCoordinate = logEntryArrayToRegion(sites: trips)
        if centerCoordinate == nil {
            Text("No sites available")
        } else {
            Map(bounds: centerCoordinate,
                interactionModes: [.pan, .zoom]) {
                ForEach(trips) { trip in
                    if trip.hasLocationData {
                        Marker(trip.title, coordinate: trip.location!)
                    }
                }
            }
                .mapStyle(.standard)
                .padding(8)
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        LowerMapView(yearSelection: "2023")
    }
}


func logEntryArrayToRegion(sites: [LogEntry]) -> MapCameraBounds? {
    var averageLatitude: Double = 0.0
    var averageLongitude: Double = 0.0
    var count: Int = 0
    
    for site in sites {
        if site.hasLocationData {
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
    
    let rect = MKMapRect(origin: MKMapPoint(CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude)), size: MKMapSize(width: 100, height: 100))
    let bounds = MapCameraBounds(centerCoordinateBounds: rect)
    return (bounds)
}
