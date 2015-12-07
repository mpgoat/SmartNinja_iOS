//
//  LocationWeather.swift
//  Weather
//
//  Created by miha perne on 29/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation

class LocationWeather:NSObject, NSCoding{
    
    var location : String?
    //var weather : String?
    
    init (location: String){// weather: String
        self.location = location
        //self.weather = weather
    }
    
    required init(coder taskDecoder: NSCoder) {
        location = taskDecoder.decodeObjectForKey("location") as? String
        //weather = taskDecoder.decodeObjectForKey("weather") as? String
    }
    
    func encodeWithCoder(taskCoder: NSCoder) {
        taskCoder.encodeObject(location, forKey: "location")
        //taskCoder.encodeObject(weather, forKey: "weather")
    }
}