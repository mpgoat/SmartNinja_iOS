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
        manager = CLLocationManager()
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    func displayLocaitonInfo(placeMark: CLPlacemark) -> [String]{
        var output = [String]()
    
        
        if let locationName = placeMark.addressDictionary?["Name"] as? String{
            output.append(locationName)
        }
        if let street = placeMark.addressDictionary?["Thoroughfare"] as? String{
            output.append(street)
        }
        
        if let city = placeMark.addressDictionary?["City"] as? String{
            output.append(city)
        }
        
        if let zip = placeMark.addressDictionary?["ZIP"] as? String{
            output.append(zip)
        }
        
        if let country = placeMark.addressDictionary?["Country"] as? String{
            output.append(country)
        }
        
        if let isoCountryCode = placeMark.ISOcountryCode{
            output.append(isoCountryCode)
        }
        return output
    }
    
    func getCurrentLocation() -> CLLocation?{
        if let lokacija = manager.location{
            return lokacija
        }
        return nil
    }
    
    func getUsersClosestCity(coordinates: CLLocation, completion: (answer: [String]) -> Void){
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.coordinate.latitude, longitude: coordinates.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location)
            {
                (placemarks, error) -> Void in
                let placeArray = placemarks as [CLPlacemark]!
                let placeMark = placeArray[0]
                completion(answer: self.displayLocaitonInfo(placeMark))
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print (locations.first) // ko se lokacija updejta se poslje delegate, sicer ne.
        print("Updated Location")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error: \(error)")
    }
}