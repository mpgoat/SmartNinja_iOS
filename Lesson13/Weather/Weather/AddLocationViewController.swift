//
//  LocationViewController.swift
//  Weather
//
//  Created by miha perne on 26/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

protocol WeatherDataDelegate : NSObjectProtocol {
    func weatherDataDidFinish (addLocationViewController : AddLocationViewController)
}

class AddLocationViewController: UIViewController {
    
    weak var delegate: WeatherDataDelegate?
    lazy var weatherManager = Weather()
    lazy var manager = LocationWeatherManager.shared
    lazy var location = String()
    
    var checkmark: Bool?
    @IBOutlet weak var checkedLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func checkLocationButton(sender: UIButton) {
        if locationTextField.text! != ""{
            _ = weatherManager.getWeatherForCity(locationTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: ""), completion: {
                (tempInfo: JSON?) in
                if let podatki = tempInfo{
                    print(podatki)
                    if !(podatki["cod"]=="404"){
                        let temperature = Int((podatki["main"]["temp"].double! - 32) / 1.8)
                        let city = String(podatki["name"])
                        print(temperature)
                        
                        self.checkmark = true
                        let trimmedCity = city.stringByReplacingOccurrencesOfString(" ", withString: "")
                        self.location = trimmedCity
                        
                        self.manager.addLocationWeather(LocationWeather(location: trimmedCity))
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.checkedLabel.text = "All OK, location set to: \(city)"
                        })
                        print(self.delegate)
                        self.delegate?.weatherDataDidFinish(self)
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), {
                            self.checkedLabel.text = "error, no location named \(self.locationTextField.text!)"
                            self.checkmark = false
                        })
                    }
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.text = ""
        checkedLabel.text = ""
    }
}
