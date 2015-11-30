//
//  File.swift
//  Weather
//
//  Created by miha perne on 29/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation

class UpdateWeather: NSOperation{
    
    var temp: String?
    
    let city: String
    init(city: String) {
        self.city = city
    }
    
    override func main() {
        
        _ = getWeatherForCity(city.stringByReplacingOccurrencesOfString(" ", withString: ""), completion: {
            (tempInfo: JSON?) in
            if let podatki = tempInfo{
                print(podatki)
                if !(podatki["cod"]=="404"){
                    let temperature = Int((podatki["main"]["temp"].double! - 32) / 1.8)
                    self.temp = "\(temperature)"
                    print(temperature)
                }
            }
        })
    }
    
    private func returnCurrentWeather(data: JSON?) -> JSON?{
        if data != nil{
            return data
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