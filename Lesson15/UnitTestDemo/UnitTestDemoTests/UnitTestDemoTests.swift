//
//  UnitTestDemoTests.swift
//  UnitTestDemoTests
//
//  Created by miha perne on 07/12/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import XCTest
@testable import UnitTestDemo
//@testable import Car

class UnitTestDemoTests: XCTestCase {
    
    var car: Car?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        car = Car()
        car!.name = "Polo"
        car!.make = "VW"
        car!.speed = 250.0
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        car = nil
    }
    
    func testCarString() {
        
        let string = car?.carString()
        
        XCTAssert(string == "VW Polo", "String should be equal")
        //1 assert na unit test
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testMaxSpeed(){
        
        let value = car?.maxSpeed()
        
        XCTAssert(value == car!.speed * 1.5, "neki ne dela")
        XCTAssert(true, "")
        
    }
    
    
}
