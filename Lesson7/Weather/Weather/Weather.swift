//
//  Weather.swift
//  Weather
//
//  Created by miha perne on 07/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation
import CoreLocation

class Weather{

    private func returnCurrentWeather(data: JSON) -> JSON{
        return data
    }
    
    func getWeatherforLocation(location: CLLocation, completion: (currentConditions: JSON) -> Void) -> NSURLSessionTask?{
        let apiKey = "ad1249e2a18603219a34df7fccd28011"
        if let weatherUrl = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/\(location.coordinate.latitude),\(location.coordinate.longitude)"){

            let urlSession = NSURLSession.sharedSession()
            let task = urlSession.dataTaskWithURL(weatherUrl) { data, response, error -> Void in
                if error != nil {
                    print(error)
                }
                
                if let jsonData = data{
                    let json = JSON(data: jsonData)
                    
                    let currentSummary = json["currently"]
                    completion(currentConditions: self.returnCurrentWeather(currentSummary))
                }
            }
            task.resume()
            return task
        }
        return nil
    }
}

