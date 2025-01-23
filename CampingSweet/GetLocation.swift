//
//  GetLocation.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 1/13/25.
//

import Foundation
import CoreLocation


public class GetLocation: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var locationCallback: ((CLLocation?) -> Void)!
    var didFailWithError: Error?
    
    @Published var hasLocationServices = false
    
    public func run(callback: @escaping (CLLocation?) -> Void) {
        locationCallback = callback
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestWhenInUseAuthorization()
        hasLocationServices = CLLocationManager.locationServicesEnabled()
        if hasLocationServices { manager.startUpdatingLocation() }
        else { locationCallback(nil) }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationCallback(locations.last!)
        manager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didFailWithError = error
        locationCallback(nil)
        manager.stopUpdatingLocation()
    }
    
    deinit {
        manager.stopUpdatingLocation()
    }
}

