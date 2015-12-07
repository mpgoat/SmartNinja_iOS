//
//  LocationWeatherManager.swift
//  Weather
//
//  Created by miha perne on 29/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation

class LocationWeatherManager: NSObject{
    
    static let shared = LocationWeatherManager()
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    var locationWeather = [LocationWeather]()
    
    var allLocationWeathers : [LocationWeather] {
        if locationWeather.isEmpty {
            loadDataFromStorage()
        }
        return locationWeather
    }
    
    func addLocationWeather (lw : LocationWeather) {
        
        if locationWeather.isEmpty {
            loadDataFromStorage()
        }
        
        locationWeather.append(lw)
        print("added new LocationWeather")
        saveDataToStorage()
    }
    
    func saveDataToStorage() {
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(locationWeather)
        userDefaults.setObject(savedData, forKey: "locationWeather")
        userDefaults.synchronize()
    }
    
    func loadDataFromStorage(){
        if let fetchedLocationWeather = userDefaults.objectForKey("locationWeather") as? NSData {
            if let decodedLocationWeather = (NSKeyedUnarchiver.unarchiveObjectWithData(fetchedLocationWeather) as? [LocationWeather]){
                locationWeather = decodedLocationWeather
                userDefaults.synchronize()
            }
        }
    }
}