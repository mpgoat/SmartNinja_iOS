/*
Napiši razred, ki predstavlja denarno enoto, katero bo pretvarjal drug razred. Razred ima le eno lastnost, ki označuje tip enote (npr. EUR, USD, …). Napiši še en razred, ki predstavlja pretvornik enot. Razred naj ima metodo, ki sprejme vrednost in enoto v kateri je vrednost ter instanco razreda enote, v katero naj vrednost pretvori. Metoda naj vrača tuple: pretvorjeno vrednost in tečaj, katerega je pretvornik uporabil. Metoda izgleda nekaj podobnega:

convert (value, startCurrency, targetCurrency) -> convertedValue, targetCurrency
Implementiraj metodo, da bo znala pretvoriti dolarje v evre.

Zapiši nekaj primerov uporabe obeh razredov v Playground, katerega shraniš v direktorij Lesson2. Nalogo ter morebitna vprašanja in težave objavi na SmartNinja forumu.
*/

class Currency {

    var currencyType: String
    
    init(currencyType: String){
        self.currencyType = currencyType
    }
}

class CurrencyConverter: Currency {
    
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

var currencyConverter = CurrencyConverter(currencyType: "USD")

let EUR = Currency(currencyType: "EUR")
let USD = Currency(currencyType: "USD")
let GBP = Currency(currencyType: "GBP")
let JPY = Currency(currencyType: "JPY")

var EUR2USD = currencyConverter.convertCurrency(100, startCurrency: EUR, targetCurrency: USD)
var EUR2GBP = currencyConverter.convertCurrency(100, startCurrency: EUR, targetCurrency: GBP)
var USD2JPY = currencyConverter.convertCurrency(100, startCurrency: USD, targetCurrency: JPY)

//vrne nil
var JPY2USD = currencyConverter.convertCurrency(100, startCurrency: JPY, targetCurrency: USD)

print(EUR2USD!)




