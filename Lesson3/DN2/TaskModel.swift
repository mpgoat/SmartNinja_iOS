//
//  TaskModel.swift
//  DN2
//
//  Created by miha perne on 21/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation

enum Priority: String{
    case Normal, High, Mega
    
    var toString : String {
        switch self {
        case .Normal: return "Normal";
        case .High: return "High";
        case .Mega: return "Mega";
        }
    }
}

enum Status: String{
    case Started, Finished, Procrastinatig, InProgress
    
    var toString : String {
        switch self {
        case .Started: return "Started";
        case .Finished: return "Finished"
        case .Procrastinatig: return ".Procrastinatig";
        case .InProgress: return "InProgress";
        }
    }
}

class Task{
    
    var dateOfCreation: NSDate
    var dateOfLastChange: NSDate
    
    var taskName: String{
        didSet{
            dateOfCreation = NSDate()
            dateOfLastChange = NSDate()
        }
    }

    var priority: Priority{
        didSet{
            dateOfLastChange = NSDate()
        }
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

class TaskManager {
    var tasks = [Task]()
    
    func addTask(task: Task) {
        self.tasks.append(task)
    }
    
    func deleteTask(task: Task) {
        if let result = tasks.indexOf({$0.taskName == task.taskName}){
            self.tasks.removeAtIndex(result)
        }
    }
    
    func deleteAllTasks(){
        self.tasks.removeAll()
    }
    func returnTaskNameAsString() -> String{
        if tasks.count > 0{
            for task in tasks{
                return "\(task.taskName)"
            }
        }
        return "no task in queue"
    }
    
    func returnNumberOfTasksInQueue() -> String {
        return "Currently there are \(tasks.count) tasks in queue"
    }
    
}
