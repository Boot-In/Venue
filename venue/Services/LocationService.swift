//
//  LocationService.swift
//  venue
//
//  Created by Dmitriy Butin on 10.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import CoreLocation

class LocationService: NSObject {
    static let shared = LocationService()
    var clManager = CLLocationManager()
    var latitude: Double = 0
    var longitude: Double = 0
    
    func start() {
        clManager.delegate = self
        clManager.requestAlwaysAuthorization()
        clManager.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locValue>",locValue)
        latitude = locValue.latitude
        longitude = locValue.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.restricted:
            print("GPS Restricted Access to location")
        case CLAuthorizationStatus.denied:
            print("GPS User denied access to location")
        case CLAuthorizationStatus.notDetermined:
            print("GPS Status not determined")
        default:
            print("GPS Allowed to location Access")
        }
        //  delegate?.locationManager(didChangeAuthorization: status)
    }
}
