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
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let tasksFetchRequest = NSFetchRequest(entityName: "Tasks")
        let sortDescriptor = NSSortDescriptor(key: "task", ascending: true)
        tasksFetchRequest.sortDescriptors = [sortDescriptor]
        
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
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            print("An error occurred")
        }
        
    }
    
    func taskAddedHandler(notification: NSNotification){
         dispatch_async(GlobalUserInteractiveQueue){
            do {
                try self.fetchedResultsController.performFetch()
                //self.fetchedResultsController.managedObjectContext.reset()
            } catch {
                print("An error occurred")
            }
            //self.fetchedResultsController.managedObjectContext.reset()
            self.taskTableView.reloadData()
            self.fetchedResultsController.managedObjectContext.reset()
        }
        
    }
    
    func taskDeletedHandler(notification: NSNotification){
        dispatch_async(GlobalMainQueue){
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
                print("An error occurred")
            }
            self.taskTableView.reloadData()
        }
        
    }
    
    
    // MARK: TableView Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("called numberOfSectionsInTableView")
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("called tableView1")
        if let sections = fetchedResultsController.sections {
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
        
        if let managedTask = fetchedResultsController.objectAtIndexPath(indexPath) as? NSManagedObject,
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
            if let managedTask = fetchedResultsController.objectAtIndexPath(indexPath) as? NSManagedObject{
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