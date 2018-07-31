//
//  LocationManager.swift
//  Interview
//
//  Created by Developer on 7/31/18.
//  Copyright © 2018 Roman Ganzha. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, Router {

    var lastLocation: CLLocation?
    
    static let shared = LocationManager()
    typealias getLocationBlock = (_ location: CLLocation) -> Void
    private var locationBlock : (getLocationBlock)?
    
    typealias ILocationManagerPremissionBlock = (_ access: Bool) -> Void
    private var premissionBlock : (ILocationManagerPremissionBlock)?
    
    lazy var manager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        return locationManager
    }()
    
    func checkCLPermission(WithCompletionBlock completion: (ILocationManagerPremissionBlock)? = nil) {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if let block = completion {
            switch authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                block(true)
            case .notDetermined:
                premissionBlock = block
                manager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                block(false)
            }
        }
    }
    
    func startUpdatingLocation() {
        checkCLPermission { [weak self] (authorized) in
            if authorized {
                self?.manager.startUpdatingLocation()
            } else {
                self?.openApplicationSettings()
            }
        }
    }
    
    func getLocation(_ completion: @escaping(getLocationBlock)) {
        locationBlock = completion
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lastLocation = location
            if let block = locationBlock {
                block(location)
                locationBlock = nil
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let block = premissionBlock {
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                block(true)
            case .denied, .restricted:
                block(false)
            default:
                break
            }
        }
    }
}
