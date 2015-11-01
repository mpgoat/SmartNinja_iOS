//
//  CurrencyByLocation.swift
//  Demo1
//
//  Created by miha perne on 29/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation
import CoreLocation

class Location : NSObject, CLLocationManagerDelegate {
    var manager : CLLocationManager
    override init () {
        manager = CLLocationManager() //dobi delegate ker manager.delegate = self
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() -> CLLocation?{
        if let lokacija = manager.location{
            return lokacija
        }
        return nil
    }
    
    func getUsersClosestCity(coordinates: CLLocation) -> String{
        var returnValue = ""
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.coordinate.latitude, longitude: coordinates.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location)
            {//completionHandler
                (placemarks, error) -> Void in
                
                let placeArray = placemarks as [CLPlacemark]!
                
                //var placeMark: CLPlacemark!
                let placeMark = placeArray[0]
                
                // Address dictionary
                //print(placeMark.addressDictionary)
                
                if let locationName = placeMark.addressDictionary?["Name"] as? String{
                    print(locationName)
                }

                if let street = placeMark.addressDictionary?["Thoroughfare"] as? String{
                    print(street)
                }

                if let city = placeMark.addressDictionary?["City"] as? String{
                    print(city)
                }

                if let zip = placeMark.addressDictionary?["ZIP"] as? String{
                    print(zip)
                }

                if let country = placeMark.addressDictionary?["Country"] as? String{
                    returnValue = country
                    print(country)
                }
        }
        return returnValue
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print (locations.first) // ko se lokacija updejta se poslje delegate, sicer ne.
        print("Updated Location")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error: \(error)")
    }
}