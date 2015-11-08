//
//  TaskManager.swift
//  DN2
//
//  Created by miha perne on 25/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation

class TaskManager{
    
    static let sharedInstance = TaskManager()
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    lazy var tasks = [Task]()
    
    init(){
        self.loadDataFromStorage()
    }
    
    func addTask(task: Task) {
        tasks.append(task)
        NSNotificationCenter.defaultCenter().postNotificationName("taskAdded", object: nil)
        saveDataToStorage()
    }
    
    /*
    func deleteTask(task: Task) {
        if let result = tasks.indexOf({$0.taskName == task.taskName}){
            tasks.removeAtIndex(result)
            saveDataToStorage()
        }
    }
    */
    
    func deleteAllTasks(){
        tasks.removeAll()
        saveDataToStorage()
    }
    
    /*
    func returnTaskNameAsString() -> String{
        if tasks.count > 0{
            for task in tasks{
                return "\(task.taskName)"
            }
        }
        return "no task in queue"
    }
    */
    
    func returnLastTaskNameAndDate() -> String {
        if let lastTask = tasks.last{
            let formatter = NSDateFormatter() //imej le eno instanco ker je ful pocasna!!!
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            return "Task \(lastTask.taskName) created \(formatter.stringFromDate(lastTask.dateOfCreation))."
        }
        return "Task List is empty"
    }
    
    func returnNumberOfTasksInQueue() -> String {
        return "Currently there are \(tasks.count) tasks in queue"
    }
    
    func saveDataToStorage() {
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(tasks)
        userDefaults.setObject(savedData, forKey: "tasks")
        userDefaults.synchronize()
    }
    
    func loadDataFromStorage(){
        if let fetchedTasks = userDefaults.objectForKey("tasks") as? NSData {
            if let decodedTasks = (NSKeyedUnarchiver.unarchiveObjectWithData(fetchedTasks) as? [Task]){
                tasks = decodedTasks
                userDefaults.synchronize()
            }
        }
    }
}