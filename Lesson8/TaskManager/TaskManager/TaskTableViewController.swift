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
    
    //@IBOutlet weak var tableView: UITableView!

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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "taskAddedHandler:", name: "taskAdded", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "taskDeletedHandler:", name: "taskDeleted", object: nil)

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }

    }
    
    func taskAddedHandler(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
                print("An error occurred")
            }
            self.taskTableView.reloadData()
        })
        
    }
    
    func taskDeletedHandler(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
                print("An error occurred")
            }
            self.taskTableView.reloadData()
        })
        
    }

    
    // MARK: TableView Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("called numberOfSectionsInTableView")
        if let sections = fetchedResultsController.sections {
            print(sections.count)
            return sections.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("called tableView1")
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            //vsak task je svoj section
            print(currentSection.numberOfObjects)
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
            let task = managedTask.valueForKey("task") as? Task{ //Zakaj moram tukaj to uporabit?
                if let image = managedTask.valueForKey("taskImage") as? NSData{
                    print("yolooo")
                    taskImage = prepareImageForPresentation(image)
                }
                cell.setCell(task.taskName, taskDetails: task.details, taskPriority: task.priority!, taskImage: taskImage)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return ("Task at: \(currentSection.name)")
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            if let managedTask = fetchedResultsController.objectAtIndexPath(indexPath) as? NSManagedObject{
                context.deleteObject(managedTask)
                do {
                    print("sejvaaam")
                    try self.context.save()
                    NSNotificationCenter.defaultCenter().postNotificationName("taskDeleted", object: nil)
                } catch {
                    print("An error WHILE SAVING")
                }
                self.taskTableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let taskDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("taskDetail") as! TaskDetailViewController
        
        taskDetailViewController.taskName = "test"
        taskDetailViewController.taskDetails = "detajli"
        
        self.presentViewController(taskDetailViewController, animated: true, completion: nil)
    }
}
