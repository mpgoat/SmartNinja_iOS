//
//  ViewController.swift
//  Demo1
//
//  Created by miha perne on 19/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

enum AlertAction{
    case okAction
    case areYouSureAction
}

class FirstViewController: UIViewController, UITextFieldDelegate {
    
    var targetCurrency: Currency = Currency(currencyType: "USD")
    lazy var location = Location()
    
    @IBOutlet weak var currencyInputTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var showConvertedResult: UILabel!
    @IBOutlet weak var changedTargetCurrency: UILabel!
    //lokacija:
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!

    
    @IBOutlet weak var toUsdButton: UIButton!
    @IBOutlet weak var toCadButton: UIButton!
    @IBOutlet weak var toJpyButton: UIButton!
    
    @IBAction func getLocation(sender: UIButton){
        if let koordinate = location.getCurrentLocation(){
            print(koordinate)
            
            location.getUsersClosestCity(koordinate) {
                //(answer: [String]) -> Void)
                (locationInfo: [String]) in
                print("locInfo:\(locationInfo)")
                
                //print("moje mesto je asinhrono: \(mesto)")
                
                self.streetLabel.text = locationInfo[0]
                self.cityLabel.text = locationInfo[2]
                self.countryLabel.text = locationInfo[4]
                
                switch locationInfo[2]{
                case "Ljubljana":
                    self.targetCurrency = Currency(currencyType: "EUR")
                    self.createAlert("You are already using EUR! in Ljubljana!", alertMessage: "You can exit app safely.", action: .okAction)
                case "London":
                    self.targetCurrency = Currency(currencyType: "GBP")
                case "Tokyo":
                    self.targetCurrency = Currency(currencyType: "JPY")
                    self.toUsdButton.selected = false
                    self.toCadButton.selected = false
                    self.toJpyButton.selected = true
                case "Moscow":
                    self.targetCurrency = Currency(currencyType: "RUB")
                default:
                    self.targetCurrency = Currency(currencyType: "USD")
                    self.toUsdButton.selected = true
                    self.toCadButton.selected = false
                    self.toJpyButton.selected = false
                }
            }
        }
    }
    
    @IBAction func convertToCurrentTitle(sender: UIButton) {
        if let convertToCurrency = sender.currentTitle{
            switch convertToCurrency{
            case "To USD":
                targetCurrency = Currency(currencyType: "USD")
                changedTargetCurrency.text = "USD"
                toUsdButton.selected = true
                toCadButton.selected = false
                toJpyButton.selected = false
                showConvertedResult.text = "0.0"
            case "To JPY":
                targetCurrency = Currency(currencyType: "JPY")
                changedTargetCurrency.text = "JPY"
                toUsdButton.selected = false
                toCadButton.selected = false
                toJpyButton.selected = true
                showConvertedResult.text = "0.0"
            case "To CAD":
                targetCurrency = Currency(currencyType: "CAD")
                changedTargetCurrency.text = "CAD"
                toUsdButton.selected = false
                toCadButton.selected = true
                toJpyButton.selected = false
                showConvertedResult.text = "0.0"
            default: "To USD"
            }
        }
    }
    
    @IBAction func convertCurrency(sender: UIButton){
        if let validNumbers = Double(currencyInputTextField.text!){
            let convertedValue = validNumbers.convertFromEurToTargetCurrency(targetCurrency)
            showConvertedResult.text = "\(convertedValue!.0)"
            showConvertedResult.hidden = false
        }
        else{
            let alert = UIAlertController(title: "Invalid number!", message:"Please type a valid number", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyInputTextField.delegate = self
        currencyInputTextField.keyboardType = .DecimalPad
        
        let tapOutsideOfKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tapOutsideOfKeyboard)
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
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
}

