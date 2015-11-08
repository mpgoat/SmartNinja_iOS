//
//  ViewController.swift
//  Weather
//
//  Created by miha perne on 07/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    lazy var weather = Weather()
    lazy var location = Location()
    
    @IBAction func getWeather(sender: UIButton) {
        
        if let currentLocation = location.getCurrentLocation(){
            print(currentLocation)
            
            weather.getWeatherforLocation(currentLocation){
                (tempInfo: JSON) in
                print(tempInfo)
                let selectedHtml: String?
                let temperature = Int((tempInfo["temperature"].double! - 32) / 1.8)
                let icon = tempInfo["icon"]
                let summary = tempInfo["summary"]
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.temperatureLabel.text = "\(temperature) °C"
                    self.weatherLabel.text = "\(summary)"
                })
                
                switch icon {
                case "clear-day":
                    selectedHtml = "clearDay"
                case "clear-night":
                    selectedHtml = "clearNight"
                case "rain":
                    selectedHtml = "rain"
                case "snow":
                    selectedHtml = "snow"
                case "sleet":
                    selectedHtml = "sleet"
                case "wind":
                    selectedHtml = "wind"
                case "fog":
                    selectedHtml = "fog"
                case "cloudy":
                    selectedHtml = "cloudy"
                case "partly-cloudy-day":
                    selectedHtml = "partlyCloudyDay"
                case "partly-cloudy-night":
                    selectedHtml = "partlyCloudyNight"
                default:
                    selectedHtml = "clearDay"
                }

                self.iconWebView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(selectedHtml, ofType: "html")!)))


            }
            
            location.getUsersClosestCity(currentLocation) {
                (locationInfo: [String]) in
                self.locationLabel.text = locationInfo[2]
                print("locInfo:\(locationInfo)")
            }

        }
    }

    
    
    @IBOutlet weak var iconWebView: UIWebView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.text = ""
        weatherLabel.text = ""
        temperatureLabel.text = ""
    }
}

