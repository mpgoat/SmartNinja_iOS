//
//  ViewController.swift
//  Weather
//
//  Created by miha perne on 07/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit
import CoreGraphics



class PresentWeatherViewController: UIViewController {
    
    lazy var weather = Weather()
    var city : String = "ljubljana"
    
    var timer: NSTimer? = nil
    var timer2: NSTimer? = nil
    let interval: NSTimeInterval = 10
    var timerOn: Bool = false

    
    @IBAction func getWeather(sender: UIButton) {
        if timerOn == false {
            print("timer on")
            timerOn = true
            updateWeather()
            timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "updateWeather", userInfo: nil, repeats: true)
            sender.setTitle("Stop Updating!", forState: .Normal)
        }
        else if timerOn == true{
            print("timer off")
            timer!.invalidate()
            timer = nil
            sender.setTitle("Get Weather!", forState: .Normal)
        }
        
        UIView.animateWithDuration(0.5, animations: {
            self.getWeatherButton.transform = CGAffineTransformMakeScale(3.0, 3.0)
            self.getWeatherButton.transform = CGAffineTransformRotate(self.getWeatherButton.transform, CGFloat(M_PI))
            }, completion: { _ in
                UIView.animateWithDuration(1.0, animations: {
                    self.getWeatherButton.transform = CGAffineTransformIdentity
                    }, completion: { _ in })
                UIView.animateWithDuration(3.0, delay: 0.5, options: .CurveEaseOut, animations: {
                    self.temperatureLabel.transform = CGAffineTransformMakeScale(1.1, 1.1)
                    //self.locationLabel.alpha = 1.0
                    self.weatherLabel.alpha = 1.0
                    self.iconWebView.alpha = 1.0
                    self.temperatureLabel.alpha = 1.0
                    }, completion: {_ in })
        })
    }
    
    func updateWeather(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        weather.getWeatherForCity(city){
            (tempInfo: JSON?) in
            if let podatki = tempInfo{
                if !(podatki["cod"]=="404"){
                    print(podatki)
                    print(podatki["weather"])
                    
                    let selectedHtml: String?
                    let temperature = Int(podatki["main"]["temp"].double! - 273)
                    let location = podatki["name"]
                    let country = podatki["sys"]["country"]
                    let icon = podatki["weather"][0]["icon"]
                    let summary = podatki["weather"][0]["description"]
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.locationLabel.text = "\(location), \(country)"
                        self.temperatureLabel.text = "\(temperature) °C"
                        self.weatherLabel.text = "\(summary)"
                    })
                    
                    switch icon {
                    case "01d":
                        selectedHtml = "clearDay"
                    case "01n":
                        selectedHtml = "clearNight"
                    case "09d", "09n", "10d", "10n":
                        selectedHtml = "rain"
                    case "13d", "13n":
                        selectedHtml = "snow"
                    case "11d", "11n":
                        selectedHtml = "sleet"
                        //case "wind":
                        //  selectedHtml = "wind"
                    case "50d", "50n":
                        selectedHtml = "fog"
                    case "03d", "03n", "04d", "04n":
                        selectedHtml = "cloudy"
                    case "02d":
                        selectedHtml = "partlyCloudyDay"
                    case "02n":
                        selectedHtml = "partlyCloudyNight"
                    default:
                        selectedHtml = "clearDay"
                    }
                    
                    self.iconWebView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(selectedHtml, ofType: "html")!)))
                    
                    UIView.animateWithDuration(3.0, delay: 0.5, options: .CurveEaseOut, animations: {
                        self.temperatureLabel.transform = CGAffineTransformMakeScale(1.1, 1.1)
                        //self.locationLabel.alpha = 1.0
                        self.weatherLabel.alpha = 1.0
                        self.iconWebView.alpha = 1.0
                        self.temperatureLabel.alpha = 1.0
                        }, completion: {_ in })
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.locationLabel.text = "Setting to Defaults"
                        self.temperatureLabel.text = "💩"
                        self.weatherLabel.text = "Location Does Not Exist"
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "neki", userInfo: nil, repeats: false)
                    })
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
    }
    func neki (){
        self.city = "ljubljana"
    }
    
    override func viewWillAppear(animated: Bool) {
        updateWeather()
    }

    
    @IBOutlet weak var getWeatherButton: UIButton!
    
    @IBOutlet weak var iconWebView: UIWebView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationChangedHandler:", name: "locationChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appInterupted", name:UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appBecameActive", name:UIApplicationDidBecomeActiveNotification, object: nil)
        locationLabel.text = "Ljubljana"
        weatherLabel.text = ""
        temperatureLabel.text = ""

    }
    
    func locationChangedHandler(notification: NSNotification){
        dispatch_async(GlobalMainQueue){
            var userInfo = notification.userInfo!
            print(userInfo)
            let location = userInfo["location"] as! String
            self.city = location
        }
    }
    
    func appInterupted(){
        print("app interrupted")
        if timerOn == true{
        print("timer paused")
        timer!.invalidate()
        }
    }
    
    func appBecameActive(){
        print("app active")
        if timerOn == true{
            print("timer resumed")
            NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "updateWeather", userInfo: nil, repeats: true)
        }else{
            updateWeather()
        }
    }
    
    deinit{
        //pobrisi timer
        if timerOn == true{
        timer!.invalidate()
        }
        self.timer = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

