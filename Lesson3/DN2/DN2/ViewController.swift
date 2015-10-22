//
//  ViewController.swift
//  DN2
//
//  Created by miha perne on 21/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let taskManager = TaskManager()

    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskPriorityTextField: UITextField!
    @IBOutlet weak var showAlerts: UILabel!
    @IBOutlet weak var detailsTextField: UITextField!
    
    @IBAction func deleteAll(sender: UIButton) {
        taskManager.deleteAllTasks()
        updateQueueText()
    }
    
    var priority = Priority(rawValue: "Normal")!

    @IBAction func selectPriorityButton(sender: UIButton) {
        if let prioritySelected = sender.currentTitle{
            switch prioritySelected{
                case "Normal":
                    priority = Priority(rawValue: "Normal")!
                    taskPriorityTextField.text = "Normal"
                case "High":
                    priority = Priority(rawValue: "High")!
                    taskPriorityTextField.text = "High"
                case "Mega":
                    priority = Priority(rawValue: "Mega")!
                    taskPriorityTextField.text = "Mega"
                default: "Normal"
            }
        }
    }
    
    @IBAction func addTask(sender: UIButton) {
        if let taskName = taskNameTextField.text, detailsText = detailsTextField.text{
            
            let detailsTextToEnter = detailsText
            
            if taskName.isEmpty{
                createAlert("Task Name is Empty!", alertMessage: "Please enter a Task name")
            }
            else if detailsText.isEmpty{
                createAlert("Details Content is Empty!", alertMessage: "Please enter some details")
            }
            else{
                let newTask = Task(taskName: taskName, priority: priority, details: detailsTextToEnter, status: .Started)
                taskManager.addTask(newTask)
                
                //reset input fields
                taskPriorityTextField.text = "Normal"
                taskNameTextField.text = ""
                //update how many tasks are stored
                updateQueueText()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        taskPriorityTextField.enabled = false
        let tapOutsideOfKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tapOutsideOfKeyboard)
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func createAlert(alertTitle: String, alertMessage: String){
        let alert = UIAlertController(title: alertTitle, message:alertMessage, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Yes master.", style: .Default) { _ in })
        self.presentViewController(alert, animated: true){}
    }
    
    func updateQueueText(){
        showAlerts.text = taskManager.returnNumberOfTasksInQueue()
    }

}

