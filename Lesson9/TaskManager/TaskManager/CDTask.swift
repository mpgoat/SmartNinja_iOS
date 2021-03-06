//
//  Task.swift
//  DN2
//
//  Created by miha perne on 21/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation
import CoreData
/*
enum Priority: String{
    case Normal = "Normal"
    case High = "High"
    case Mega = "Mega"
}

enum Status: String{
    case Started = "Started"
    case Finished = "Finished"
    case Procrastinatig = "Procrastinatig"
    case InProgress = "InProgress"
}
*/
//NSObject ze implementira svoj equatable conformance
class CDTask: NSManagedObject{//, NSCoding
    
    @NSManaged var dateOfCreation: NSDate
    @NSManaged var dateOfLastChange: NSDate
    
    @NSManaged var taskName: String
    /*{
    didSet{
    dateOfCreation = NSDate()
    dateOfLastChange = NSDate()
    }
    }
    */
    
    var priority = Priority(rawValue: "Normal"){
        didSet{
            dateOfLastChange = NSDate()
        }
    }
    
    var status = Status(rawValue: "Started"){
        didSet{
            dateOfLastChange = NSDate()
        }
    }
    
    @NSManaged var details: String
    /*{
    didSet{
    dateOfLastChange = NSDate()
    }
    }
    */
    
    func descriptionOfTask(description: String){
        self.descriptionOfTask(description)
    }
    
    convenience init(taskName: String, priority: Priority, details: String, status: Status, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entityForName("Tasks", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.taskName = taskName
        self.priority = priority
        self.details = details
        self.status = status
        self.dateOfCreation = NSDate()
        self.dateOfLastChange = NSDate()
    }
    
    /*
    required init(coder taskDecoder: NSCoder) {
    status = taskDecoder.decodeObjectForKey("status") as? Status
    priority = taskDecoder.decodeObjectForKey("priority") as? Priority
    taskName = taskDecoder.decodeObjectForKey("taskName") as! String
    details = taskDecoder.decodeObjectForKey("details") as! String
    dateOfCreation = taskDecoder.decodeObjectForKey("dateOfCreation") as! NSDate
    dateOfLastChange = taskDecoder.decodeObjectForKey("dateOfLastChange") as! NSDate
    }
    
    func encodeWithCoder(taskCoder: NSCoder) {
    taskCoder.encodeObject(taskName, forKey: "taskName")
    taskCoder.encodeObject(priority as? AnyObject, forKey: "priority")
    taskCoder.encodeObject(details, forKey: "details")
    taskCoder.encodeObject(status as? AnyObject, forKey: "status")
    taskCoder.encodeObject(dateOfCreation, forKey: "dateOfCreation")
    taskCoder.encodeObject(dateOfLastChange, forKey: "dateOfLastChange")
    }
    */
    /*
    override func isEqual(object: AnyObject?) -> Bool {
    if let firstTask = object as? Task {
    return taskName == firstTask.taskName
    }
    return false
    }
    */
}

