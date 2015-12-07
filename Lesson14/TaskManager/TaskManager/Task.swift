//
//  Task.swift
//  DN2
//
//  Created by miha perne on 21/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MagicalRecord


enum Priority: NSNumber{
    case Normal = 0 
    case High = 1
    case Mega = 2
}

enum Status: String{
    case Started = "Started"
    case Finished = "Finished"
    case Procrastinatig = "Procrastinating"
    case InProgress = "InProgress"
}

@objc(Task)
class Task: NSManagedObject{
    
    class func create(name: String, priority: Int, status: String, details: String){
        let neki = Task.MR_createEntity()
        neki.name = name
        neki.priority = priority
        neki.status = status
        neki.details = details
        neki.dateOfCreation = NSDate()
        
        NSManagedObjectContext.MR_context().MR_saveToPersistentStoreAndWait()
    }
    /*
    var image: UIImage?

    var prioritySetting: Priority{
        get{
            return Priority(rawValue: self.priority!)!
        }
        set{
            self.priority = newValue.rawValue
        }
    }
    
    var statusSetting: Status{
        get{
            return Status(rawValue: status!)!
        }
        set{
            self.status = newValue.rawValue
        }
    }
    
    //@NSManaged var details: String
    
    /*
    func descriptionOfTask(description: String){
        self.descriptionOfTask(description)
    }
    */
    
    /*
    init(taskName: String, priority: Priority, details: String, status: Status, image: UIImage?){
        
        self.taskName = taskName
        self.priority = prioritySetting.rawValue
        self.details = details
        self.status = statusSetting.rawValue
        self.dateOfCreation = NSDate()
        self.dateOfLastChange = NSDate()
    }
    */
    
    /*
    convenience init(name: String){
        self.init(taskName: name, priority:Priority.Normal, details: "convenience task", status: Status.Started, image: NSData?)
    }
    */
    
*/
}

