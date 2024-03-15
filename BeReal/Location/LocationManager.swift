//
//  LocationManager.swift
//  BeReal
//
//  Created by Mina on 3/12/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    static let shared = LocationManager()
    
    var currentLocation: CLLocation? {
        manager.location
    }
    
    private override init() {
        super.init()
        manager.delegate = self
        
    }
    
    func requestPersmisson() {
        
        switch manager.authorizationStatus {
            
        case .notDetermined:
            print("notDetermined")
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
            manager.requestWhenInUseAuthorization()
        case .denied:
            print("denied")
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            print("authorizedAlways")
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        @unknown default:
            break
        }
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func geoCodeLocation(longitude: Double, latitude: Double, completion: @escaping (String) ->()) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)

        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error {
                print(error.localizedDescription)
            }
            if let placemark = placemarks?.first {
                if let city = placemark.locality, let state = placemark.administrativeArea {
                    completion("\(city), \(state)")
                }
            }
        }
    }
}
