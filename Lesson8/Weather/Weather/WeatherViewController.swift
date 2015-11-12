//
//  ViewController.swift
//  Weather
//
//  Created by miha perne on 07/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit
import CoreGraphics

class WeatherViewController: UIViewController {
    
    lazy var weather = Weather()
    lazy var location = Location()
    //var initialPosition = CGPointMake(0.0, 0.0)
    
    @IBAction func getWeather(sender: UIButton) {
        
        UIView.animateWithDuration(0.5, animations: {
            //self.getWeatherButton.center = CGPointMake(250.0, 250.0)
            //self.activityView.alpha = 0.0
            self.getWeatherButton.transform = CGAffineTransformMakeScale(3.0, 3.0)
            self.getWeatherButton.transform = CGAffineTransformRotate(self.getWeatherButton.transform, CGFloat(M_PI))
            }, completion: { _ in
                UIView.animateWithDuration(1.0, animations: {
                    self.getWeatherButton.transform = CGAffineTransformIdentity
                    }, completion: { _ in })
                UIView.animateWithDuration(3.0, delay: 0.5, options: .CurveEaseOut, animations: {
                    self.temperatureLabel.transform = CGAffineTransformMakeScale(1.1, 1.1)
                    self.locationLabel.alpha = 1.0
                    self.weatherLabel.alpha = 1.0
                    self.iconWebView.alpha = 1.0
                    self.temperatureLabel.alpha = 1.0
                    }, completion: {_ in })
        })

        
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

    
    @IBOutlet weak var getWeatherButton: UIButton!
    
    @IBOutlet weak var iconWebView: UIWebView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initialPosition.x = self.locationLabel.center.x
        //initialPosition.y = self.locationLabel.center.y
        //self.locationLabel.center = CGPointMake(0.0, initialPosition.y)
        locationLabel.text = ""
        weatherLabel.text = ""
        temperatureLabel.text = ""
        self.locationLabel.alpha = 0.0
        self.weatherLabel.alpha = 0.0
        self.iconWebView.alpha = 0.0
        self.temperatureLabel.alpha = 0.0
    }
}

