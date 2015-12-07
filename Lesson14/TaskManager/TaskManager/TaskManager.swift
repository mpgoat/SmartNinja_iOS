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
import ImageIO
import MagicalRecord

class TaskManager{
    
    static let sharedInstance = TaskManager()
    
    //var userDefaults = NSUserDefaults.standardUserDefaults()
    //lazy var tasks = [Task]()
    
    //lazy var tasks = [NSManagedObject]()
    
    func saveTaskToCoreData(inputTask: Task?, inputImage: UIImage?){
        
        var imageData: NSData?
        var smallImageData: NSData?
        
        if let image = inputImage{
            let smallImage = resizeImage(image, newHeight: 300.0)
            smallImageData = self.prepareImageForSaving(smallImage)
            imageData = self.prepareImageForSaving(image)
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.context
        
        let TaskEntity = Task.MR_createEntityInContext(managedContext)

        TaskEntity.name = inputTask?.name
        TaskEntity.priority = inputTask?.priority
        TaskEntity.status = inputTask?.status
        TaskEntity.dateOfCreation = NSDate()
        TaskEntity.details = inputTask?.details
        TaskEntity.taskRelationship = []
        
        let TaskImageEntity = TaskImage.MR_createEntityInContext(managedContext)
        TaskImageEntity.taskImage = imageData
        TaskImageEntity.smallTaskImage = smallImageData
        
        do{
            try managedContext.MR_saveOnlySelfAndWaitWithError()
            //tasks.append(task)
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        managedContext.refreshAllObjects()
    }
    
    /*
    func loadFromCoreData(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.context
        
        let fetchRequest:Array = Task.MR_findAll()
        managedContext.
    }
    */
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
    
    //init(){
    //    self.loadFromCoreData()
    //}
    
    func addTask(addedTask: Task, addedImage: UIImage?) {
        
        //NSNotificationCenter.defaultCenter().postNotificationName("taskAdded", object: nil)
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
    //narstuoenarsoeitnaeirostnoeiarntoeianerestnaorintoaeirnteioarsnteioarsntoeantoeiartnsioanrstoeinarsotnoaeirstnoieanrtiea
    
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
    /*
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
*/
    
    
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

