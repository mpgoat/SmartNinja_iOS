/* 
Domača naloga 2

Spoznajte se s Playgrounds in Swift-om. Napišite 2 funkciji za izračun Fibonacci-jevega števila v Swift 2.0:

iterativno,
z uporabo rekurzije.

Funkciji kot parameter sprejemeta celo število, končni rezultat pa naj tudi izpišeta.
*/

/*
    Vrne & izpise serijo fibonaccijevih stevil oziroma nil ce na vhodu ni pozitiven int.
*/

func fibonacciZaporedjeStevilk(steviloIteracij: Int) -> [Int]? {
    if (steviloIteracij >= 0){
        var fibonacciZaporedje = [0,1]
        
        if steviloIteracij == 0 {
            return [0]
        }else if steviloIteracij == 1 {
            return fibonacciZaporedje
        }
        for iteracija in 2...steviloIteracij{
            if iteracija > steviloIteracij{
                return fibonacciZaporedje
            }else{
                fibonacciZaporedje.append(fibonacciZaporedje[iteracija-1] + fibonacciZaporedje[iteracija-2])
            }
        }
        print("\(fibonacciZaporedje)")
        return fibonacciZaporedje
    }else {
        print("Use a positive number")
        return nil
    }
}

/*
    Vrne zeljeno zaporedno fibonaccijevo stevilo (ne cele serije) oziroma nil ce na vhodu ni pozitiven int.
*/

func fibonacciNumberRecursive(steviloIteracij: Int) -> Int? {
    if (steviloIteracij >= 0){
        if steviloIteracij == 0 {
            return 0
        }
        else if steviloIteracij == 1 || steviloIteracij == 2{
            return 1
        }else{
            return (fibonacciNumberRecursive(steviloIteracij-1)! + fibonacciNumberRecursive(steviloIteracij-2)!)
        }
    }
    else {
        print("Use a positive number")
        return nil
    }
}

func printFibonacci(input: Int){
    print("\(fibonacciNumberRecursive(input)!)")
}



//ce dela ok
fibonacciZaporedjeStevilk(-56)
fibonacciZaporedjeStevilk(2)
fibonacciZaporedjeStevilk(3)
fibonacciZaporedjeStevilk(12)

fibonacciNumberRecursive(-56)
fibonacciNumberRecursive(2)
fibonacciNumberRecursive(3)
fibonacciNumberRecursive(12)

//print za rekurzivno funkcijo
printFibonacci(12)
