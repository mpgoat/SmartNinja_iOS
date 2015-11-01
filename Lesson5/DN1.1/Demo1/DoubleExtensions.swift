//
//  DoubleExtensions.swift
//  Demo1
//
//  Created by miha perne on 25/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation

extension Double {
    func convertFromEurToTargetCurrency(targetCurrency: Currency) -> (Double, String)? {
        return CurrencyConverter.sharedInstance.convertCurrency(self, startCurrency: Currency.init(currencyType: "EUR"), targetCurrency: targetCurrency)
    }
}