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
    var priority = Priority.Normal
    let imagePicker = UIImagePickerController()
    //let managedContext = AppDelegate().managedObjectContext
    var taskImage: UIImage? = nil
    
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var taskImageView: UIImageView!
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
        case 0: priority = Priority.Normal
        case 1: priority = Priority.High
        case 2: priority = Priority.Mega
        default: 0
        }
    }
    //ne deluje
    @IBAction func deleteAll(sender: UIButton) {
        if showAlerts.text == "Currently there are 0 tasks in queue"{
            createAlert("No Tasks To Delete!", alertMessage: "", action: .okAction)
        }else{
            createAlert("Are You Sure?", alertMessage: "All Tasks Will Be Deleted", action: .areYouSureAction)
        }
    }
    
    @IBAction func addTask(sender: UIButton) {
        if let taskName = self.taskNameTextField.text, detailsText = self.detailsTextField.text{
            if taskName.isEmpty{
                createAlert("Task Name is Empty!", alertMessage: "Please enter a Task name", action: .okAction)
            }
            else{
                let newTask = Task(taskName: taskName, priority: self.priority, details: detailsText, status: .Started, image: self.taskImage)
                self.taskManager.addTask(newTask, addedImage: self.taskImage)
                self.updateDisplay()
                
                UIView.animateWithDuration(0.1, delay: 0, options: [], animations: {
                    self.addTaskButton.transform = CGAffineTransformMakeScale(1.5, 1.5)
                    }, completion: {
                        completed in UIView.animateWithDuration(0.1, animations: {
                            self.addTaskButton.transform = CGAffineTransformIdentity
                        })
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "didDeactivate", name: UIApplicationWillResignActiveNotification, object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "didActivate", name: UIApplicationDidBecomeActiveNotification, object: nil)
        imagePicker.delegate = self
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
                self.updateDisplay()
            })
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default) { _ in })
        }
        self.presentViewController(alert, animated: true){}
    }
    
    func updateDisplay(){
        self.prioritySegment.selectedSegmentIndex = 0
        self.priority = .Normal
        self.detailsTextField.text = ""
        self.taskNameTextField.text = ""
        self.taskImageView.image = nil
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            taskImageView.contentMode = .ScaleAspectFit
            taskImageView.image = pickedImage
            taskImage = pickedImage
            print("success!")
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //neki naredi 
    }
}

