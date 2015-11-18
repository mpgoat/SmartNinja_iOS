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
    
    weak var context: NSManagedObjectContext!
    
    weak var cachedTask: Task?
    weak var cachedImage: UIImage?
    weak var cachedContext: NSManagedObjectContext?
    weak var cachedManagedObject: NSManagedObject?
    
    lazy var fetchedTaskResultsController: NSFetchedResultsController = {
        let tasksFetchRequest = NSFetchRequest(entityName: "Task")
        let sortDescriptor = NSSortDescriptor(key: "priority", ascending: false)
        tasksFetchRequest.sortDescriptors = [sortDescriptor]
        tasksFetchRequest.fetchBatchSize = 10

        let frc = NSFetchedResultsController(
            fetchRequest: tasksFetchRequest,
            managedObjectContext: self.context,
            sectionNameKeyPath: "task",
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    
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
                print("Task Added!")
                try self.fetchedTaskResultsController.performFetch()
            } catch {
                print("An error occurred")
            }
            self.taskTableView.reloadData() //hammer time
        }
    }
    
    func taskDeletedHandler(notification: NSNotification){
        /*
        var userInfo = notification.userInfo!
        print(userInfo)
        let indexPath = userInfo["indexPath"] as! NSIndexPath
        self.taskTableView.
        self.taskTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        */
        dispatch_async(GlobalMainQueue){
            do {
                print("Task Deleted!")
                try self.fetchedTaskResultsController.performFetch()
            } catch {
                print("An error occurred")
            }
            self.taskTableView.reloadData()
        }
    }
    
    func taskChangedHandler(notification: NSNotification){
        dispatch_async(GlobalMainQueue){
            do {
                print("Task Updated!")
                try self.fetchedTaskResultsController.performFetch()
            } catch {
                print("An error occurred")
            }
            self.taskTableView.reloadData()
        }
    }
    
    
    // MARK: TableView Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedTaskResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedTaskResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
                
                let tableColor: UIColor = {
                    switch task.priority{
                    case .Normal?: return UIColor.whiteColor()
                    case .High?: return UIColor.orangeColor()
                    case .Mega?: return UIColor.redColor()
                    default: return UIColor.whiteColor()
                    }
                }()
                
                if task.status?.rawValue == "Finished"{
                    cell.backgroundColor = UIColor.lightGrayColor()
                }else if task.status?.rawValue != "Finished"{
                    cell.backgroundColor = tableColor
                }
                cell.setCell(task, image: taskImage)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedTaskResultsController.sections {
            let currentSection = sections[section]
            return ("Task at: \(currentSection.name)")
        }
        return nil
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            if let managedTask = fetchedTaskResultsController.objectAtIndexPath(indexPath) as? NSManagedObject{
                do {
                    context.deleteObject(managedTask)
                    try self.context.save()
                    let userInfo = ["indexPath": indexPath]
                    NSNotificationCenter.defaultCenter().postNotificationName("taskDeleted", object: nil, userInfo: userInfo)
                } catch {
                    print("An error while saving after deletion")
                }
                self.taskTableView.reloadData()
            }
        }
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
    
    func prepareImageForPresentation(data: NSData) -> UIImage?{
        guard let image = UIImage(data: data) else {
            print("image conversion error")
            return nil
        }
        return image
    }
    
    override func didReceiveMemoryWarning() {
        do {
            try self.context.save()
            print("memory warning")
        } catch {
            print("An error while saving at memory warning")
        }
        context.reset()
    }
}