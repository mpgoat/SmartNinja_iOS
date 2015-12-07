//
//  File.swift
//  Weather
//
//  Created by miha perne on 29/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation
import Alamofire

class UpdateWeather: NSOperation{
    
    var city: String = ""
    let apiKey = "abedbd7dea6a859555144d6184b4834d"
    let units : String = "metric"
    
    var completionHandler : ((Double, AnyObject, AnyObject) -> Void)?
    
    override func main() -> Void {
        print(city)
        let parameters = ["q": city , "units": units , "appid" : apiKey]
        if let weatherUrl = NSURL(string: "http://api.openweathermap.org/data/2.5/weather"){
            
        Alamofire.request(.GET, weatherUrl, parameters: parameters).responseJSON { response in
            if response.result.error != nil {
                print(response.result.error)
                print("invalid city")
            }
            
            if let jsonData = response.result.value{
                let weather = jsonData["main"]!
                let temperature = weather as! [String : AnyObject]
                    if let temp = temperature["temp"] as? NSNumber {
                    
                        if let completionHandler = self.completionHandler {
                        completionHandler(temp.doubleValue, weather!, jsonData)
                        }
                    }
                }
            }
        }
    }
}
