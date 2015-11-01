//
//  Currency.swift
//  Demo1
//
//  Created by miha perne on 25/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation

class Currency: Equatable, Comparable {
    
    var currencyType: String
    
    init(currencyType: String){
        self.currencyType = currencyType
    }
}

// protocol conforming
//equatable
func ==(firstCurrency: Currency, secondCurrency: Currency) -> Bool{
    return firstCurrency.currencyType == secondCurrency.currencyType && secondCurrency.currencyType == firstCurrency.currencyType
}
//comparable
func <(firstCurrency: Currency, secondCurrency: Currency) -> Bool{
    return firstCurrency.currencyType < secondCurrency.currencyType
}