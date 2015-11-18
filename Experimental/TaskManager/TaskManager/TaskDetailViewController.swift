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
    var priority: Priority?
    var status: Status?
    
    @IBOutlet weak var taskDetailImageView: UIImageView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskStatus: UISegmentedControl!
    @IBOutlet weak var taskPriority: UISegmentedControl!
    
    var receivedTask: Task?
    var taskImage: UIImage?
    
    @IBAction func selectPrioritySegment(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            priority = Priority(rawValue: "Normal")!
            
        case 1:
            priority = Priority(rawValue: "High")!
            
        case 2:
            priority = Priority(rawValue: "Mega")!
            
        default: 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var prioritae: String?
        var statoos: String?
        
        if let priority = receivedTask!.priority,
            let status =  receivedTask!.status{
                prioritae = priority.rawValue
                statoos = status.rawValue
        }
        
        self.taskNameLabel.text = "\(receivedTask!.taskName)\n\(receivedTask!.details)\nPriority: \(prioritae!)\nStatus: \(statoos!)"
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
            case "Finished"?: return 1
            case "Procrastinatig"?: return 2
            case "InProgress"?: return 3
            default: return 0
            }
        }
        self.taskPriority.selectedSegmentIndex = intPriority
        self.taskStatus.selectedSegmentIndex = intStatus
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
