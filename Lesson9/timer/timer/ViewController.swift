//
//  ViewController.swift
//  timer
//
//  Created by miha perne on 16/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

enum AlertAction{
    case okAction
    case areYouSureAction
}

import UIKit

enum Status{
    case Started
    case Paused
    case Nil
}

class ViewController: UIViewController {

    var timer: NSTimer?
    var time = 0.0
    var status = Status.Nil
    
    @IBOutlet weak var startTimerButton: UIButton!
    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBAction func startTimer(sender: UIButton) {
        switch status{
        case .Started:
            timer?.invalidate()
            status = .Paused
            print("penis")
            sender.setTitle("Start Timer", forState: .Normal)
        case .Paused:
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "neki", userInfo: "Done", repeats: true)
            status = .Started
            sender.setTitle("Pause Timer", forState: .Normal)
        case .Nil:
            time = 30
            status = .Started
            countDownLabel.text = "\(time)"
            sender.setTitle("Pause Timer", forState: .Normal)
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "neki", userInfo: "Done", repeats: true)
        }
    }
    
    @IBAction func plusTenSeconds(sender: AnyObject) {
        time+=10
    }
    
    func neki(){
        time=time-0.1
        countDownLabel.text = "\(time.roundToPlaces(2))"
        
        if(time < 10){
            self.countDownLabel.textColor = UIColor.redColor()
        }
        if time <= 0.01{
            self.countDownLabel.textColor = UIColor.blackColor()
            countDownLabel.text = "Done!"
            resetTimer()
        }
    }
    
    func resetTimer(){
        status = .Nil
        timer!.invalidate()
        timer = nil
        startTimerButton.setTitle("Start Timer", forState: .Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appInterupted", name:UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appBecameActive", name:UIApplicationDidBecomeActiveNotification, object: nil)
        // se klice tudi ko se app zazene

        startTimerButton.setTitle("Start Timer", forState: .Normal)
        self.countDownLabel.textColor = UIColor.blackColor()
    }
    func appInterupted(){
        print("app interrupted")
        timer!.invalidate() //pause
    }
    
    func appBecameActive(){
        print("app active")
        self.countDownLabel.textColor = UIColor.blackColor()
        if time != 0{
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "neki", userInfo: "Done", repeats: true)
        }
    }

    deinit{
        //pobrisi timer
        timer!.invalidate()
        self.timer = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension Double {
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}

