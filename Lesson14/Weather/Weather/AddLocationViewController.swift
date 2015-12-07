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
    
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.qualityOfService = .Background
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    
    weak var delegate: WeatherDataDelegate?
    //lazy var weatherManager = Weather()
    lazy var manager = LocationWeatherManager.shared
    lazy var location = String()
    
    var checkmark: Bool?
    @IBOutlet weak var checkedLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func checkLocationButton(sender: UIButton) {
        
        let operation = UpdateWeather()
        operation.city = locationTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        operation.completionHandler = { temp, weather, data in
            print(temp)
            print(weather)
            if let city = data["name"]!{
                self.checkmark = true
                let trimmedCity = city.stringByReplacingOccurrencesOfString(" ", withString: "")
                self.location = trimmedCity
                self.manager.addLocationWeather(LocationWeather(location: trimmedCity))
                dispatch_async(dispatch_get_main_queue(), {
                    self.checkedLabel.text = "All OK, location set to: \(city)"
                })
            }
        }
        downloadQueue.addOperation(operation)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.text = ""
        checkedLabel.text = ""
    }
}
