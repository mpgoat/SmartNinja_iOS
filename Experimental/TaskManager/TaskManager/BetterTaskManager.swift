//
//  BetterTaskManager.swift
//
//
//  Created by miha perne on 25/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//
/*
import Foundation
import UIKit
import CoreData
import ImageIO
import CoreStore

class BetterTaskManager{
    
    static let sharedInstance = BetterTaskManager()
    
    //var userDefaults = NSUserDefaults.standardUserDefaults()
    
    //lazy var tasks = [Task]()
    var tasks: NSManagedObject?
    
    
    
    //func fetchAllTasks(){
    //    let people = CoreStore.fetchAll(From(tasks))
    //}
    
    
    func saveTaskToCoreData(inputTask: Task?, inputImage: UIImage?){
        var imageData: NSData?
        var smallImageData: NSData?
        if let image = inputImage{
            //make small version of photo
            let smallImage = resizeImage(image, newHeight: 300.0)
            
            imageData = self.prepareImageForSaving(image)
            smallImageData = self.prepareImageForSaving(smallImage)
            //print(smallImageData!)
        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Tasks", inManagedObjectContext: managedContext)
        let task = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        task.setValue(inputTask, forKey: "task")
        task.setValue(imageData, forKey: "taskImage")
        task.setValue(smallImageData, forKey: "smallTaskImage")
        
        
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
    
    func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage {
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    init(){
        let dataStack = DataStack(
            modelName: "TaskManager")
        do {
            try CoreStore.addSQLiteStoreAndWait()
        }
        catch {
            // ...
        }
    }
    
    func addTask(addedTask: Task, addedImage: UIImage?) {
        NSNotificationCenter.defaultCenter().postNotificationName("taskAdded", object: nil)
        saveTaskToCoreData(addedTask, inputImage: addedImage)
    }
    
    func returnLastImage() -> UIImage?{
        if let lastImage = tasks.last?.valueForKey("smallTaskImage") as? NSData{
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

}

*/