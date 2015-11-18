//
//  TaskDetailViewController.swift
//  TaskManager
//
//  Created by miha perne on 11/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit
import CoreData

class TaskDetailViewController: UIViewController {
    
    var context: NSManagedObjectContext!
    var managedObject: NSManagedObject?
    var indexPath: NSIndexPath?
    
    var priority: Priority?
    var status: Status?
    var receivedTask: Task?
    var taskImage: UIImage?
    
    var taskName: String?
    var taskDetails: String?
    var changed = false
    
    @IBOutlet weak var taskDetailImageView: UIImageView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskPriority: UISegmentedControl!
    @IBOutlet weak var taskStatus: UISegmentedControl!
    
    @IBAction func taskStatus(sender: UISegmentedControl) {
        changed = true
        switch sender.selectedSegmentIndex{
            case 0: status = Status(rawValue: "Started")
            case 1: status = Status(rawValue: "InProgress")
            case 2: status = Status(rawValue: "Procrastinating")
            case 3: status = Status(rawValue: "Finished")
            default: 0
        }
    }
    
    @IBAction func selectPrioritySegment(sender: UISegmentedControl) {
        changed = true
        switch sender.selectedSegmentIndex{
        case 0: priority = Priority(rawValue: "Normal")
        case 1: priority = Priority(rawValue: "High")
        case 2: priority = Priority(rawValue: "Mega")
        default: 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskNameLabel.text = "\(receivedTask!.taskName)\n\(receivedTask!.details)\nPriority: \(receivedTask!.priority!)\nStatus: \(receivedTask!.status!)"
        self.taskDetailImageView.image = taskImage
        
        var intPriority: Int{
            switch self.receivedTask?.priority?.rawValue{
            case "Normal"?: return 0
            case "High"?: return 1
            case "Mega"?: return 2
            default: return 0
            }
        }
        
        var intStatus: Int{
            switch self.receivedTask?.status?.rawValue{
            case "Started"?: return 0
            case "InProgress"?: return 1
            case "Procrastinating"?: return 2
            case "Finished"?: return 3
            
            default: return 0
            }
        }
        
        self.taskPriority.selectedSegmentIndex = intPriority
        self.taskStatus.selectedSegmentIndex = intStatus
        self.priority = receivedTask?.priority
        self.status = receivedTask?.status
        self.taskName = receivedTask?.taskName
        self.taskDetails = receivedTask?.details
    }
    
    override func viewWillDisappear(animated: Bool) {
        if changed == true{
            let taskToSave = Task(taskName: taskName!, priority: priority!, details: taskDetails!, status: status!, image: taskImage)
            let task = managedObject
            task!.setValue(taskToSave, forKey: "task")
            do{
                try context.save()
                NSNotificationCenter.defaultCenter().postNotificationName("taskChanged", object: nil)
            }catch{
                print("error while updating Task")
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
