//
//  ViewController.swift
//  DN2
//
//  Created by miha perne on 21/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit
import CoreData

enum AlertAction{
    case okAction
    case areYouSureAction
}
//
class TaskViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let taskManager = TaskManager.sharedInstance
    var priority = Priority(rawValue: "Normal")!
    let imagePicker = UIImagePickerController()
    //let saveQueue = dispatch_queue_create("saveQueue", DISPATCH_QUEUE_CONCURRENT)
    let managedContext = AppDelegate().managedObjectContext
    var taskImage: UIImage? = nil
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var showAlerts: UILabel!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var showLastTask: UILabel!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    
    @IBAction func selctImage(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
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
            //let detailsTextToEnter = detailsText

            if taskName.isEmpty{
                createAlert("Task Name is Empty!", alertMessage: "Please enter a Task name", action: .okAction)
            }
            else if detailsText.isEmpty{
                createAlert("Details Content is Empty!", alertMessage: "Please enter some details", action: .okAction)
            }
            else{
                //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                //let managedContext = appDelegate.managedObjectContext
                //let newTask = Task(taskName: taskName, priority: priority, details: detailsText, status: .Started, insertIntoManagedObjectContext: managedContext)
                let newTask = Task(taskName: taskName, priority: priority, details: detailsText, status: .Started, image: taskImage)
                taskManager.addTask(newTask, addedImage: taskImage)
                updateDisplay()
            }
        }
    }
    
    
    @IBOutlet weak var taskImageView: UIImageView!
    
    @IBOutlet weak var loadedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //image picker delegate
        imagePicker.delegate = self
        
        //gesture recogniser for keyboard dismissal
        let tapOutsideOfKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tapOutsideOfKeyboard)
        updateDisplay()
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
                //self.taskManager.deleteAllTasks() se ne dela
                self.updateDisplay()
            })
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default) { _ in })
        }
        
        self.presentViewController(alert, animated: true){}
    }
    
    func updateDisplay(){
        prioritySegment.selectedSegmentIndex = 0
        taskNameTextField.text = ""
        showAlerts.text = taskManager.returnNumberOfTasksInQueue()
        showLastTask.attributedText = taskManager.returnLastTaskNameAndDate()
        detailsTextField.text = "Enter Details"
        taskImageView.image = nil
        loadedImageView.image = taskManager.returnLastImage()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            taskImageView.contentMode = .ScaleAspectFit
            taskImageView.image = pickedImage
            
            taskImage = pickedImage
            //loadedImageView.image = taskImage
            print("success!")
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

