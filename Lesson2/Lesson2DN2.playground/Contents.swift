/*
Napiši razred, ki predstavlja opravilo (npr. Task). Vsebuje naj vsaj naslednje lastnosti:

ime,
datum dodajanja,
datum spremembe,
prioriteta,
stanje.

Smiselno izberi podatkovne tipe, le stanje naj bo posebnega tipa, ki je enum. Glede na tvoje izbrano opravilo, lahko dodaš še več smiselnih lastnosti. Implementiraj še metodo description in convenience initializer-je za izpis opravila.
*/

import Foundation


enum Priority{
    case Normal, High, Mega
}

class Task {
    
    var dateOfCreation: NSDate
    var dateOfLastChange: NSDate
    
    var taskName: String{
        didSet{
            dateOfCreation = NSDate()
            dateOfLastChange = NSDate()
        }
    }
    
    enum Priority{
        case Normal, High, Mega
    }
    
    var priority: Priority{
        didSet{
            dateOfLastChange = NSDate()
        }
    }
    
    enum Status{
        case Started, Finished, Procrastinatig, InProgress
    }
    
    var status: Status{
        didSet{
            dateOfLastChange = NSDate()
        }
    }
    
    var details: String{
        didSet{
            dateOfLastChange = NSDate()
        }
    }
    
    func descriptionOfTask(description: String){
        self.descriptionOfTask(description)
    }
    
    init(taskName: String, priority: Priority, details: String, status: Status){
        self.taskName = taskName
        self.priority = priority
        self.details = details
        self.status = status
        self.dateOfCreation = NSDate()
        self.dateOfLastChange = NSDate()
    }
    
    convenience init(name: String){
        self.init(taskName: name, priority:Priority.Normal, details: "convenience task", status: Status.Started)
    }
}

var firstTask = Task(name: "My first Task")
firstTask.status
firstTask.priority
firstTask.details
firstTask.dateOfCreation
firstTask.dateOfLastChange

var secondTask = Task(taskName: "My second task", priority: .Mega, details: "mega important task. need finished yesterday.", status: .Started)
secondTask.status
secondTask.priority
secondTask.details
secondTask.dateOfCreation
secondTask.dateOfLastChange