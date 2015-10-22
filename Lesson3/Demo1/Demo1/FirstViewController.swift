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
                self.changedTargetCurrency.text = "USD"
                self.toUsdButton.selected = true
                self.toCadButton.selected = false
                self.toJpyButton.selected = false
                self.showConvertedResult.text = "0.0"
            case "To JPY":
                targetCurrency = Currency(currencyType: "JPY")
                self.changedTargetCurrency.text = "JPY"
                self.toUsdButton.selected = false
                self.toCadButton.selected = false
                self.toJpyButton.selected = true
                self.showConvertedResult.text = "0.0"
            case "To CAD":
                targetCurrency = Currency(currencyType: "CAD")
                self.changedTargetCurrency.text = "CAD"
                self.toUsdButton.selected = false
                self.toCadButton.selected = true
                self.toJpyButton.selected = false
                self.showConvertedResult.text = "0.0"
            default: "To USD"
            }
        }
    }
    
    @IBAction func convertCurrency(sender: UIButton){
        if let validNumbers = Double(currencyInputTextField.text!){
            let startCurrency = Currency(currencyType: "EUR")
            let currencyConverterObject = CurrencyConverter()
            
            let convertedValue = currencyConverterObject.convertCurrency(validNumbers, startCurrency: startCurrency, targetCurrency: targetCurrency)
            print(convertedValue)
            self.showConvertedResult.text = "\(convertedValue!.0)"
            self.showConvertedResult.hidden = false
        }
        else{ // ne dela ker je double zmeraj valid, tudi ce so same pike vrne 0.0 wtf?
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

