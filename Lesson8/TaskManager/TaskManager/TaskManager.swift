//
//  TaskManager.swift
//  DN2
//
//  Created by miha perne on 25/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TaskManager{
    
    static let sharedInstance = TaskManager()
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    //lazy var tasks = [Task]()
    lazy var tasks = [NSManagedObject]()
    
    func saveTaskToCoreData(inputTask: Task?, inputImage: UIImage?){
        var imageData: NSData?
        if let image = inputImage{
            imageData = self.prepareImageForSaving(image)
        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Tasks", inManagedObjectContext: managedContext)
        let task = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        task.setValue(inputTask, forKey: "task")
        task.setValue(imageData, forKey: "taskImage")
        
        
        /*
        task.setValue(inputTask.taskName, forKey: "taskName")
        task.setValue(inputTask.details, forKey: "taskDetails")
        task.setValue(inputTask.priority as? AnyObject, forKey: "taskPriority")
        task.setValue(inputTask.status as? AnyObject, forKey: "taskStatus")
        task.setValue(inputTask.dateOfCreation, forKey: "dateOfCreation")
        task.setValue(inputTask.dateOfLastChange, forKey: "dateOfLastChange")
        */
        do{
            try managedContext.save()
            tasks.append(task)
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    func loadFromCoreData(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Tasks")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            tasks = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func prepareImageForSaving(image:UIImage) -> NSData?{
            guard let imageData = UIImageJPEGRepresentation(image, 1)
                else {
                print("image conversion error")
                return nil
            }
        return imageData
    }
    
    func prepareImageForPresentation(data: NSData) -> UIImage?{
        guard let image = UIImage(data: data)
            else {
                print("image conversion error")
                return nil
        }
        return image
    }
    
    init(){
        self.loadFromCoreData()
    }
    
    func addTask(addedTask: Task, addedImage: UIImage?) {
        //neki.append(addedTask)
        NSNotificationCenter.defaultCenter().postNotificationName("taskAdded", object: nil)
        saveTaskToCoreData(addedTask, inputImage: addedImage)
    }
    
    /*
    func deleteTask(task: Task) {
        if let result = tasks.indexOf({$0.taskName == task.taskName}){
            tasks.removeAtIndex(result)
            saveDataToStorage()
        }
    }
    */
    
    /*
    func deleteAllTasks(){
        tasks.removeAll()
        saveTaskToCoreData(tasks.last?.valueForKey("task") as? Task, inputImage: nil)
        
    }
*/
    
    
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
    func returnLastImage() -> UIImage?{
        if let lastImage = tasks.last?.valueForKey("taskImage") as? NSData{
            return prepareImageForPresentation(lastImage)
        }
        return nil
    }
    
    func returnLastTaskNameAndDate() -> NSAttributedString {
        //let lastCDTask = neki.last as? Task
        var image: UIImage? = nil
        if let lastTask = tasks.last?.valueForKey("task") as? Task{
            if let lastImage = tasks.last?.valueForKey("taskImage") as? NSData{
                image = prepareImageForPresentation(lastImage)
            }
            let formatter = NSDateFormatter() //imej le eno instanco ker je ful pocasna!!!
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            // status in prioriteta = nil za shranjene podatke!!!!!!!
            return NSAttributedString(string: "Ime: \(lastTask.taskName) created \(formatter.stringFromDate(lastTask.dateOfCreation))\nPrioriteta: \(String(lastTask.priority!)) \nOpis: \(lastTask.details) \nStatus: \(String(lastTask.status!)) \nCreated: \(lastTask.dateOfCreation) \nChanged: \(lastTask.dateOfLastChange) \nslikica: \(image)", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
            }
        return NSAttributedString(string: "Task List is empty", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
    }
    
    func returnNumberOfTasksInQueue() -> String {
        return "Currently there are \(tasks.count) tasks in queue"
    }
    /*
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
    */
}

