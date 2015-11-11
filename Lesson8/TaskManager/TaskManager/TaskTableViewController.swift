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
    
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var tableView: UITableView!

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
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }
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
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("called tableView2")
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        //tukaj zmeraj faila cast. Zakaj?
        print("printam frc")
        print(fetchedResultsController.objectAtIndexPath(indexPath))
        if let task = fetchedResultsController.objectAtIndexPath(indexPath) as? Task{
            cell.textLabel?.text = task.taskName
            print(task.taskName)
            cell.detailTextLabel?.text = task.details
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
}
