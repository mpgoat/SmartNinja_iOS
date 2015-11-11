//
//  TaskDetailViewController.swift
//  TaskManager
//
//  Created by miha perne on 11/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet weak var taskDetailImageView: UIImageView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskDateLabel: UILabel!
    var taskName: String?
    var taskDetails: String?
    var taskPriority: String?
    var taskDate: String?
    
    @IBOutlet weak var taskDetailsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskNameLabel.text = taskName
        self.taskDetailsLabel.text = taskDetails
        self.taskPriorityLabel.text = taskPriority
        self.taskDateLabel.text = taskDate
        // Do any additional setup after loading the view.
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
