//
//  TaskTableViewController.swift
//  DN2
//
//  Created by miha perne on 07/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var taskTableView: UITableView!
    
    var context: NSManagedObjectContext!
    
    var cachedTask: Task?
    var cachedImage: UIImage?
    var cachedContext: NSManagedObjectContext?
    var cachedManagedObject: NSManagedObject?
    
    lazy var fetchedTaskResultsController: NSFetchedResultsController = {
        
        let tasksFetchRequest = NSFetchRequest(entityName: "Task")
        //let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: tasksFetchRequest, completionBlock: nil)
        
        //asyncRequest.fetchRequest.fetchBatchSize = 10
        tasksFetchRequest.fetchBatchSize = 10
        
        let sortDescriptor = NSSortDescriptor(key: "task", ascending: true)
        //asyncRequest.fetchRequest.sortDescriptors = [sortDescriptor]
        tasksFetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController(
            fetchRequest: tasksFetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: "task",
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    /*
    lazy var fetchedImageResultsController: NSFetchedResultsController = {
        let tasksFetchRequest = NSFetchRequest(entityName: "TaskImage")
        let sortDescriptor = NSSortDescriptor(key: "taskImage", ascending: true)
        tasksFetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController(
            fetchRequest: tasksFetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: "taskImage",
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if traitCollection.forceTouchCapability == .Available{
            registerForPreviewingWithDelegate(self, sourceView: taskTableView)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "taskAddedHandler:", name: "taskAdded", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "taskDeletedHandler:", name: "taskDeleted", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "taskChangedHandler:", name: "taskChanged", object: nil)
        
        do {
            try fetchedTaskResultsController.performFetch()
            
        } catch {
            print("An error occurred")
        }
        
    }
    
    func taskAddedHandler(notification: NSNotification){
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            do {
                try self.fetchedTaskResultsController.performFetch()
                //try self.fetchedImageResultsController.performFetch()
            } catch {
                print("An error occurred")
            }
            self.taskTableView.reloadData()
        }
    }
    
    func taskDeletedHandler(notification: NSNotification){
        //var userInfo = notification.userInfo!
        //print(userInfo)
        //let indexPath = userInfo["indexPath"] as! NSIndexPath
        //self.taskTableView.
        //self.taskTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        //
        dispatch_async(GlobalMainQueue){
            do {
                print("Deleted!")
                try self.fetchedTaskResultsController.performFetch()
                //try self.fetchedImageResultsController.performFetch()
            } catch {
                print("An error occurred")
            }
            self.taskTableView.reloadData()
        }
    }
    
    func taskChangedHandler(notification: NSNotification){
        dispatch_async(GlobalMainQueue){
            do {
                print("Updated!")
                try self.fetchedTaskResultsController.performFetch()
                //try self.fetchedImageResultsController.performFetch()
            } catch {
                print("An error occurred")
            }
            self.taskTableView.reloadData()
        }
    }
    
    
    // MARK: TableView Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("called numberOfSectionsInTableView")
        if let sections = fetchedTaskResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("called tableView1")
        if let sections = fetchedTaskResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }

    func prepareImageForPresentation(data: NSData) -> UIImage?{
        guard let image = UIImage(data: data)
            else {
                print("image conversion error")
                return nil
        }
        return image
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var taskImage: UIImage? = nil
        let cell: TaskTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TaskTableViewCell
        
        if let managedTask = fetchedTaskResultsController.objectAtIndexPath(indexPath) as? NSManagedObject,
            let task = managedTask.valueForKey("task") as? Task{
                if let image = managedTask.valueForKey("smallTaskImage") as? NSData{
                    
                    taskImage = prepareImageForPresentation(image)
                    print(taskImage?.size)
                }
                switch task.priority?.rawValue{
                case "Normal"?: cell.backgroundColor = UIColor.whiteColor()
                case "High"?: cell.backgroundColor = UIColor.orangeColor()
                case "Mega"?: cell.backgroundColor = UIColor.redColor()
                default: cell.backgroundColor = UIColor.whiteColor()
                }
                if task.status?.rawValue == "Finished"{
                    cell.backgroundColor = UIColor.grayColor()
                }else if task.status?.rawValue != "Finished"{
                    cell.backgroundColor = UIColor.whiteColor()
                }
                cell.setCell(task, image: taskImage)
        }
        
        return cell
    }
    /*
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if let sections = fetchedTaskResultsController.sections {
    let currentSection = sections[section]
    return ("Task at: \(currentSection.name)")
    }
    return nil
    }
    */
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            if let managedTask = fetchedTaskResultsController.objectAtIndexPath(indexPath) as? NSManagedObject{
                //if let managedImage = fetchedImageResultsController.objectAtIndexPath(indexPath) as? NSManagedObject{
                //    context.deleteObject(managedImage)
                //}
                context.deleteObject(managedTask)
                do {
                    try self.context.save()
                    let userInfo = ["indexPath": indexPath]
                    NSNotificationCenter.defaultCenter().postNotificationName("taskDeleted", object: nil, userInfo: userInfo)
                    //self.fetchedResultsController.managedObjectContext.reset()
                } catch {
                    print("An error WHILE SAVING")
                }
                self.taskTableView.reloadData()
            }
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showTaskDetail") {
            let indexPath = taskTableView.indexPathForSelectedRow
            let vc = segue.destinationViewController as! TaskDetailViewController
            
            if let managedTask = fetchedTaskResultsController.objectAtIndexPath(indexPath!) as? NSManagedObject{
                if let task = managedTask.valueForKey("Task") as? Task{
                    if let img = managedTask.valueForKey("smallTaskImage") as? NSData{
                        vc.taskImage = prepareImageForPresentation(img)
                    }
                    vc.managedObject = managedTask
                    vc.receivedTask = task
                    vc.indexPath = indexPath
                    vc.context = context
                }
            }
        }
    }
}