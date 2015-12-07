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

class TaskManager{
    
    static let sharedInstance = TaskManager()
    
    //var userDefaults = NSUserDefaults.standardUserDefaults()
    //lazy var tasks = [Task]()
    
    //lazy var tasks = [NSManagedObject]()
    
    func saveTaskToCoreData(inputTask: Task?, inputImages: [UIImage]?){
        
        //var imageData: NSData?
        let imgShared = Image.sharedInstance
        var imagePaths = String()
        var smallImageData: NSData?
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let TasksEntity = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedContext)
        let task = NSManagedObject(entity: TasksEntity!, insertIntoManagedObjectContext: managedContext)
        
        if let images = inputImages{
            for img in images{
                let smallImg = resizeImage(img, newHeight: 300.0)
                let imgPath = imgShared.getImagePath(smallImg)
                imagePaths+=(","+imgPath) //lol
            }
            print("imagePaths:")
            print(imagePaths)
            task.setValue(imagePaths, forKey: "imagePaths")
        }
        
        if let images = inputImages{
            let firstImg = images[0]
            let smallImage = resizeImage(firstImg, newHeight: 300.0)
            
            //imageData = self.prepareImageForSaving(image)
            smallImageData = self.prepareImageForSaving(smallImage)
            //print(smallImageData!)
        }
        
        do{
            let json = try NSString(data: NSJSONSerialization.dataWithJSONObject(["task":(inputTask?.taskName)!], options: NSJSONWritingOptions(rawValue: 0)), encoding: NSUTF8StringEncoding)
            print(json)
            task.setValue(json, forKey: "json")
        }
        catch{
            print("error")
        }
        
        task.setValue(inputTask, forKey: "task")
        task.setValue(inputTask?.priority?.rawValue, forKey: "priority")
        task.setValue(inputTask?.dateOfCreation, forKey: "dateOfCreation")
        task.setValue(smallImageData, forKey: "smallTaskImage")


        do{
            try managedContext.save()
            //tasks.append(task)
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        managedContext.refreshAllObjects()
    }
    
    
    func loadFromCoreData(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Task")
        
        do {
            //let results =
            try managedContext.executeFetchRequest(fetchRequest)
            //tasks = results as! [NSManagedObject]
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
    
    //init(){
    //    self.loadFromCoreData()
    //}
    
    func addTask(addedTask: Task, addedImage: [UIImage]?) {
        NSNotificationCenter.defaultCenter().postNotificationName("taskAdded", object: nil)
        if let images = addedImage{
            saveTaskToCoreData(addedTask, inputImages: images)
        }else{
            saveTaskToCoreData(addedTask, inputImages: nil)
        }
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

