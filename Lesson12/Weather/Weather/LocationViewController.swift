//
//  LocationViewController.swift
//  Weather
//
//  Created by miha perne on 26/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    lazy var weather = Weather()
    var checkmark: Bool?
    @IBOutlet weak var checkedLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func checkLocationButton(sender: UIButton) {
        if locationTextField.text! != ""{
            _ = weather.getWeatherForCity(locationTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: ""), completion: {
                (tempInfo: JSON?) in
                if let podatki = tempInfo{
                    print(podatki)
                    if !(podatki["cod"]=="404"){
                        let temperature = Int((podatki["main"]["temp"].double! - 32) / 1.8)
                        let city = String(podatki["name"])
                        print(temperature)
                        
                        self.checkmark = true
                        let trimmedCity = city.stringByReplacingOccurrencesOfString(" ", withString: "")
                        let userInfo = ["location": trimmedCity]
                        NSNotificationCenter.defaultCenter().postNotificationName("locationChanged", object: nil, userInfo: userInfo)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.checkedLabel.text = "All OK, location set to: \(city)"
                        })
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
