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

class ViewController: UIViewController {

    var timer: NSTimer?
    var cifre = 0.0
    
    @IBOutlet weak var startTimerButton: UIButton!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBAction func startTimer(sender: UIButton) {
        if startTimerButton.titleLabel!.text == "Start Timer"{
            if let _ = Double(timeTextField.text!){
                startTimer()
            }
            else{
                let alert = UIAlertController(title: "Invalid number!", message:"Please type a valid number", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                self.presentViewController(alert, animated: true){}
            }
        }else{
            resetTimer()
        }

    }
    
    @IBAction func plusTenSeconds(sender: AnyObject) {
        cifre+=10
    }
    func neki(){
        cifre=cifre-0.1
        countDownLabel.text = "\(cifre.roundToPlaces(2))"
        
        if(cifre < 10){
            self.countDownLabel.textColor = UIColor.redColor()
        }
        if cifre <= 0.01{
            self.countDownLabel.textColor = UIColor.blackColor()
            countDownLabel.text = "Done!"
            resetTimer()
        }
    }
    
    func startTimer(){
        //timer.invalidate()
        startTimerButton.setTitle("Stop Timer", forState: .Normal)
        cifre = Double(timeTextField.text!)!
        countDownLabel.text = timeTextField.text
        timeTextField.text = nil
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "neki", userInfo: "Done", repeats: true)
    }
    func resetTimer(){
        //timer.invalidate()
        startTimerButton.setTitle("Start Timer", forState: .Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "appEnteredIntoBackGround", name:UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appInterupted", name:UIApplicationWillResignActiveNotification, object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "appActiveFromBackground", name:UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appBecameActive", name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        // se klice tudi ko se app zazene

        startTimerButton.setTitle("Start Timer", forState: .Normal)
        self.countDownLabel.textColor = UIColor.blackColor()
    }/*
    func appEnteredIntoBackGround(){
        print("app in background")
        timer.invalidate() //pause
    }
*/
    func appInterupted(){
        print("app interrupted")
        timer!.invalidate() //pause
    }
    func appBecameActive(){
        print("app active from interupted")
        self.countDownLabel.textColor = UIColor.blackColor()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "neki", userInfo: "Done", repeats: true)
    }/*
    func appActiveFromBackground(){
        print("app active")
        self.countDownLabel.textColor = UIColor.blackColor()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "neki", userInfo: "Done", repeats: true)
    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAlert(alertTitle: String, alertMessage: String, action: AlertAction){
        let alert = UIAlertController(title: alertTitle, message:alertMessage, preferredStyle: .Alert)
        
        switch action{
        case .okAction:
            alert.addAction(UIAlertAction(title: "Yes master.", style: .Default) { _ in })
        case .areYouSureAction:
            alert.addAction(UIAlertAction(title: "I Am Sure", style: .Default) { _ in })
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default) { _ in })
        }
        self.presentViewController(alert, animated: true){}
    }
    
    deinit{
        //pobrisi timer
        //cleanUpTimer()
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

