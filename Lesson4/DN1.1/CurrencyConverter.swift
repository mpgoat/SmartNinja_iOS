//
//  CurrencyModel.swift
//  Demo1
//
//  Created by miha perne on 20/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation

class CurrencyConverter{
    
    static let sharedInstance = CurrencyConverter()
    private init(){}
    
    func convertCurrency(value: Double, startCurrency: Currency, targetCurrency: Currency) -> (convertedValue: Double, targetCurrency: String)?{
        
        if let exchangeRate = getExchangeRate(startCurrency, targetCurrency: targetCurrency){
            return (value*exchangeRate, targetCurrency.currencyType)
        }
        
        print("Unknown input. startCurrency only accepts USD or EUR, targetCurrency only accepts USD, GBP, CAD, AUD, JPY.")
        return nil
    }
    
    func getExchangeRate(startCurrency: Currency, targetCurrency: Currency) -> Double? {
        
        if startCurrency.currencyType == "EUR" {
            switch targetCurrency.currencyType {
            case "USD":
                return 1.1349
            case "GBP":
                return 0.7351
            case "CAD":
                return 1.4661
            case "AUD":
                return 1.5615
            case "JPY":
                return 135.5695
            default:
                return nil
            }
        }
            
        else if startCurrency.currencyType == "USD"{
            switch targetCurrency.currencyType {
            case "EUR":
                return 0.8811
            case "GBP":
                return 0.6477
            case "CAD":
                return 1.2918
            case "AUD":
                return 1.3759
            case "JPY":
                return 119.4550
            default:
                return nil
            }
        }
        return nil
    }
    
}