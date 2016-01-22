//
//  Car.swift
//  UnitTestDemo
//
//  Created by miha perne on 07/12/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation
class Car: NSObject {
    var name: String = "Golf"
    var make: String = "VW"
    
    var engine: String = "2.0 TDI"
    
    var engineSpeedFactor = 1.5
    
    var speed: Double = 250.0
    
    
    func carString() -> String{
        return make + " " + name
    }
    
    func maxSpeed() -> Double{
        return speed * engineSpeedFactor
    }
}
