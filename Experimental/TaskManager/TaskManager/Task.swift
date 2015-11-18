//
//  Task.swift
//  DN2
//
//  Created by miha perne on 21/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation
import UIKit

enum Priority: Int{
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

//NSObject ze implementira svoj equatable conformance
class Task: NSObject, NSCoding{
    
    var image: UIImage?
    var dateOfCreation: NSDate
    var dateOfLastChange: NSDate
    
    var taskName: String{
        didSet{
            dateOfCreation = NSDate()
            dateOfLastChange = NSDate()
        }
    }

    var priority = Priority(rawValue: 0){
        didSet{
            dateOfLastChange = NSDate()
        }
    }

    var status = Status(rawValue: "Started"){
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
    
    init(taskName: String, priority: Priority, details: String, status: Status, image: UIImage?){
        self.taskName = taskName
        self.priority = priority
        self.details = details
        self.status = status
        self.dateOfCreation = NSDate()
        self.dateOfLastChange = NSDate()
    }
/*
    convenience init(name: String){
        self.init(taskName: name, priority:Priority.Normal, details: "convenience task", status: Status.Started, image: NSData?)
    }
    */
    required init(coder taskDecoder: NSCoder) {
        status = Status(rawValue: taskDecoder.decodeObjectForKey("status") as! String) ?? Status.Started
        priority = Priority(rawValue: taskDecoder.decodeObjectForKey("priority") as! Int) ?? Priority.Normal
        taskName = taskDecoder.decodeObjectForKey("taskName") as! String
        details = taskDecoder.decodeObjectForKey("details") as! String
        dateOfCreation = taskDecoder.decodeObjectForKey("dateOfCreation") as! NSDate
        dateOfLastChange = taskDecoder.decodeObjectForKey("dateOfLastChange") as! NSDate
        image = taskDecoder.decodeObjectForKey("image") as? UIImage
    }
    
    func encodeWithCoder(taskCoder: NSCoder) {
        taskCoder.encodeObject(taskName, forKey: "taskName")
        taskCoder.encodeObject(priority!.rawValue, forKey: "priority")
        taskCoder.encodeObject(details, forKey: "details")
        taskCoder.encodeObject(status!.rawValue, forKey: "status")
        taskCoder.encodeObject(dateOfCreation, forKey: "dateOfCreation")
        taskCoder.encodeObject(dateOfLastChange, forKey: "dateOfLastChange")
        taskCoder.encodeObject(image, forKey: "image")
    }
    /*
    override func isEqual(object: AnyObject?) -> Bool {
        if let firstTask = object as? Task {
            return taskName == firstTask.taskName
        }
        return false
    }
    */
}

