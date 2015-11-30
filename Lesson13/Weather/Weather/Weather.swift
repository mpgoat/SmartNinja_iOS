//
//  Weather.swift
//  Weather
//
//  Created by miha perne on 07/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class Weather: NSObject{

    private func returnCurrentWeather(data: JSON?) -> JSON?{
        if data != nil{
           return data
        }
        return nil
        
    }
    
    func getWeatherforLocation(location: CLLocation, completion: (currentConditions: JSON?) -> Void) -> NSURLSessionTask?{ //clojure
        let apiKey = "ad1249e2a18603219a34df7fccd28011"
        if let weatherUrl = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/\(location.coordinate.latitude),\(location.coordinate.longitude)"){
            print(weatherUrl)

            let urlSession = NSURLSession.sharedSession()
            let task = urlSession.dataTaskWithURL(weatherUrl) { data, response, error -> Void in
                if error != nil {
                    print(error)
                    completion(currentConditions: self.returnCurrentWeather(nil))
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
    
    func getWeatherForCity(city: String, completion: (currentConditions: JSON?) -> Void) -> NSURLSessionTask?{ //clojure
        print(city)
        let apiKey = "abedbd7dea6a859555144d6184b4834d"
        if let weatherUrl = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"){
            let urlSession = NSURLSession.sharedSession()
            let task = urlSession.dataTaskWithURL(weatherUrl) { data, response, error -> Void in
                if error != nil {
                    print(error)
                    print("invalid city")
                    completion(currentConditions: self.returnCurrentWeather(nil))
                }
                
                if let jsonData = data{
                    let json = JSON(data: jsonData)
                    
                    completion(currentConditions: self.returnCurrentWeather(json))
                }
            }
            task.resume()
            return task
        }
        return nil
    }

}

