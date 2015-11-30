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
        //tasksFetchRequest.resultType = .DictionaryResultType
        tasksFetchRequest.propertiesToFetch = ["dateOfCreation", "task", "smallTaskImage", "priority"]
        //tasksFetchRequest.propertiesToGroupBy = ["dateOfCreation"]
        

        //tasksFetchRequest.relationshipKeyPathsForPrefetching
        
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
        taskTableView.tableFooterView = UIView()
        
        if traitCollection.forceTouchCapability == .Available{
            registerForPreviewingWithDelegate(self, sourceView: taskTableView)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "taskAddedHandler:", name: "taskAdded", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "taskDeletedHandler:", name: "taskDeleted", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "taskChangedHandler:", name: "taskChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appInterupted", name:UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appBecameActive", name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        
        
        do {
            try fetchedTaskResultsController.performFetch()
            
        } catch {
            print("An error occurred")
        }
        
    }
    
    func zaznanDolgiPritisk(gestureRecognizer: UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(self.view)
            if let indexPath = taskTableView.indexPathForRowAtPoint(touchPoint) {
                
                let alert = UIAlertController(title: "Delete Task?", message:"Please confirm Task Deletion", preferredStyle: .ActionSheet)
                
                alert.addAction(UIAlertAction(title: "Delete", style: .Destructive) { _ in
                    if let managedTask = self.fetchedTaskResultsController.objectAtIndexPath(indexPath) as? NSManagedObject{
                        do {
                            self.context.deleteObject(managedTask)
                            try self.context.save()
                            let userInfo = ["indexPath": indexPath]
                            NSNotificationCenter.defaultCenter().postNotificationName("taskDeleted", object: nil, userInfo: userInfo)
                        } catch {
                            print("An error while saving after deletion")
                        }
                        self.taskTableView.reloadData()
                    }
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .Default) { _ in })
                self.presentViewController(alert, animated: true){}
            }
        }
        print("zaznan dolg pritisk")
    }
    
    func taskAddedHandler(notification: NSNotification){
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            do {
                print("Task Added!")
                try self.fetchedTaskResultsController.performFetch()
            } catch {
                print("An error occurred")
            }//hammer time
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
        //self.taskTableView.deleteSections(NSIndexSet(index: 0), withRowAnimation: .Fade)

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
    
    override func viewWillAppear(animated: Bool) {
        self.taskTableView.reloadData()
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
        
        //let resultsDict = Dictionary <NSDate, Task>()
        
        if let managedTask = fetchedTaskResultsController.objectAtIndexPath(indexPath) as? NSManagedObject,
            let task = managedTask.valueForKey("task") as? Task{
                //add cell long press gesture recogniser
                let longPress = UILongPressGestureRecognizer(target: self, action: "zaznanDolgiPritisk:")
                longPress.minimumPressDuration = 1.0
                cell.addGestureRecognizer(longPress)
                
                if let image = managedTask.valueForKey("smallTaskImage") as? NSData{
                    
                    taskImage = prepareImageForPresentation(image)
                }
                
                let tableColor: UIColor = {
                    switch task.priority{
                    case .Normal?: return UIColor.init(colorLiteralRed: (255/255), green: (250/255), blue: (250/255), alpha: 0.8)
                    case .High?: return UIColor.init(colorLiteralRed: (255/255), green: (69/255), blue: (0/255), alpha: 0.8)
                    case .Mega?: return UIColor.init(colorLiteralRed: 1, green: 0, blue: 0, alpha: 0.8)
                    default: return UIColor.whiteColor()
                    }
                }()
                
                if task.status?.rawValue == "Finished"{
                    cell.accessoryType = .Checkmark
                    cell.taskNameLabel.textColor = UIColor.lightGrayColor()
                    cell.backgroundColor = UIColor.init(colorLiteralRed: (255/255), green: (250/255), blue: (250/255), alpha: 0.8)
                }else if task.status?.rawValue != "Finished"{
                    cell.accessoryType = .None
                    cell.taskNameLabel.textColor = UIColor.blackColor()
                    cell.backgroundColor = tableColor
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
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if let managedTask = fetchedTaskResultsController.objectAtIndexPath(indexPath) as? NSManagedObject{
            if editingStyle == UITableViewCellEditingStyle.Delete{
                do {
                    context.deleteObject(managedTask)
                    try self.context.save()
                    let userInfo = ["indexPath": indexPath]
                    NSNotificationCenter.defaultCenter().postNotificationName("taskDeleted", object: nil, userInfo: userInfo)
                } catch {
                    print("An error while saving after deletion")
                }
                //self.taskTableView.deleteSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
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
        self.taskTableView.reloadData()
    }
    
    func appInterupted(){
        print("app interrupted")
    }
    
    func appBecameActive(){
        print("app active")
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}