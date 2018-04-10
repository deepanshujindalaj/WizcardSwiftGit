//
//  LocationManager.swift
//  EZER
//
//  Created by TimerackMac1 on 30/11/17.
//  Copyright © 2017 TimerackMac1. All rights reserved.
//

import Foundation
import CoreLocation
protocol LocationManagerDelegate:class {
    func didChangeinLocation(cordinate : CLLocationCoordinate2D)
    func didErrorinLocation(error: Error)
    func locationNotAvailable()
    func locationFaliedToUpdate( status:CLAuthorizationStatus)
    func locationDenied()
}
class LocationManager:NSObject,CLLocationManagerDelegate{
    weak var locationDelegate :LocationManagerDelegate?
    let locationManager = CLLocationManager()
   
    init(delegate:LocationManagerDelegate)
    {
        locationDelegate = delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        
    }
    func requestLocation()
    {
        locationManager.delegate = self
        if checkAuthorization(){
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
        else{
            locationDelegate?.locationDenied()
        }
    }
    func startUpdatingLocation()
    {
        locationManager.delegate = self
        if checkAuthorization(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        }
        else{
            locationDelegate?.locationDenied()
        }
    }
    func requestAutorizationWhenInUse()
    {
        locationManager.delegate = self
        if checkAuthorization(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        }
        else{
            locationDelegate?.locationDenied()
        }
    }
    func stopUpdatingLocation()
    {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
       // print("location paused")
    }
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
       // print("location resumed")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //print("location in error",error.localizedDescription)
        self.locationDelegate?.didErrorinLocation(error: error)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
       // print("location update" , location.coordinate)
        self.locationDelegate?.didChangeinLocation(cordinate: location.coordinate)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            locationDelegate?.locationNotAvailable()
         //   print("Location access was restricted.")
        case .denied:
            locationDelegate?.locationNotAvailable()
         //   print("User denied access to location.")
            // Display the map using the default location.
        case .notDetermined:
            locationDelegate?.locationNotAvailable()
          //  print("Location status not determined.")
        case .authorizedAlways:
        locationManager.startUpdatingLocation()
        //fallthrough
        case .authorizedWhenInUse:
              locationManager.startUpdatingLocation()
            //print("Location status is OK.")
        }
    }
    
    func checkAuthorization()-> Bool
    {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
              //  print("not det")
                locationDelegate?.locationFaliedToUpdate(status: .notDetermined)
                 return true
              case  .restricted:
              //  print("restict")
                locationDelegate?.locationFaliedToUpdate(status: .restricted)
                 return false
                case .denied:
                    locationDelegate?.locationFaliedToUpdate(status : .denied)
               // print("No access")
                return false
            case .authorizedAlways, .authorizedWhenInUse:
               return true
            }
        } else {
            //print("Location services are not enabled")
            locationDelegate?.locationFaliedToUpdate(status: .notDetermined)
            return false
        }
    }
}
