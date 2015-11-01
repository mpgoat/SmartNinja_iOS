//
//  ViewController.swift
//  DN2
//
//  Created by miha perne on 21/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

enum AlertAction{
    case okAction
    case areYouSureAction
}

class ViewController: UIViewController {
    
    let taskManager = TaskManager.sharedInstance
    var priority = Priority(rawValue: "Normal")!

    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var showAlerts: UILabel!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var showLastTask: UILabel!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    
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
    
    @IBAction func deleteAll(sender: UIButton) {
        if showAlerts.text == "Currently there are 0 tasks in queue"{
            createAlert("No Tasks To Delete!", alertMessage: "", action: .okAction)
        }else{
            createAlert("Are You Sure?", alertMessage: "All Tasks Will Be Deleted", action: .areYouSureAction)
        }
    }
    
    @IBAction func addTask(sender: UIButton) {
        if let taskName = taskNameTextField.text, detailsText = detailsTextField.text{
            
            let detailsTextToEnter = detailsText
            
            if taskName.isEmpty{
                createAlert("Task Name is Empty!", alertMessage: "Please enter a Task name", action: .okAction)
            }
            else if detailsText.isEmpty{
                createAlert("Details Content is Empty!", alertMessage: "Please enter some details", action: .okAction)
            }
            else{
                let newTask = Task(taskName: taskName, priority: priority, details: detailsTextToEnter, status: .Started)
                taskManager.addTask(newTask)
                
                //reset input fields
                prioritySegment.selectedSegmentIndex = 0
                taskNameTextField.text = ""
                //update how many tasks are stored
                updateText()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapOutsideOfKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tapOutsideOfKeyboard)
        updateText()
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func createAlert(alertTitle: String, alertMessage: String, action: AlertAction){
        let alert = UIAlertController(title: alertTitle, message:alertMessage, preferredStyle: .Alert)
        
        switch action{
        case .okAction:
            alert.addAction(UIAlertAction(title: "Yes master.", style: .Default) { _ in })
            
        case .areYouSureAction:
            alert.addAction(UIAlertAction(title: "I Am Sure", style: .Default) { _ in
                self.taskManager.deleteAllTasks()
                self.updateText()
            })
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default) { _ in })
        }
        
        self.presentViewController(alert, animated: true){}
    }
    
    func updateText(){
        showAlerts.text = taskManager.returnNumberOfTasksInQueue()
        showLastTask.text = taskManager.returnLastTaskNameAndDate()
        detailsTextField.text = "Enter Details"
    }

}

