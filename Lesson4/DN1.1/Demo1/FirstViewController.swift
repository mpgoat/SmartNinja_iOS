//
//  ViewController.swift
//  Demo1
//
//  Created by miha perne on 19/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var currencyInputTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var showConvertedResult: UILabel!
    @IBOutlet weak var changedTargetCurrency: UILabel!
    
    @IBOutlet weak var toUsdButton: UIButton!
    @IBOutlet weak var toCadButton: UIButton!
    @IBOutlet weak var toJpyButton: UIButton!
    
    
    var targetCurrency: Currency = Currency(currencyType: "USD")
    
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
            //let startCurrency = Currency(currencyType: "EUR")
            //let currencyConverterObject = CurrencyConverter()
            //let convertedValue = currencyConverterObject.convertCurrency(validNumbers, startCurrency: startCurrency, targetCurrency: targetCurrency)
            
            let convertedValue = validNumbers.convertFromEurToTargetCurrency(targetCurrency)
            showConvertedResult.text = "\(convertedValue!.0)"
            showConvertedResult.hidden = false
        }
        else{
            let alert = UIAlertController(title: "Invalid number!", message:"VAlid numbers only have one . !", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
    }
    
    override func viewDidLoad() {
        currencyInputTextField.delegate = self
        currencyInputTextField.keyboardType = .DecimalPad
        
        let tapOutsideOfKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tapOutsideOfKeyboard)
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
}

