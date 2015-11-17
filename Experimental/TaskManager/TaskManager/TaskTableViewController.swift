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
        
        do {
            try fetchedTaskResultsController.performFetch()
            
        } catch {
            print("An error occurred")
        }
        
    }
    
    func taskAddedHandler(notification: NSNotification){
         dispatch_async(GlobalUserInteractiveQueue){
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
        dispatch_async(GlobalMainQueue){
            do {
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
                cell.setCell(task.taskName, taskDetails: task.details, taskPriority: task.priority!, taskImage: taskImage)
        }
        
        return cell
    }
    /*
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if let sections = fetchedResultsController.sections {
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
                    NSNotificationCenter.defaultCenter().postNotificationName("taskDeleted", object: nil)
                    //self.fetchedResultsController.managedObjectContext.reset()
                } catch {
                    print("An error WHILE SAVING")
                }
                self.taskTableView.reloadData()
            }
        }
    }
}