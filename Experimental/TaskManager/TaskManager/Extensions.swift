//
//  TaskManagerExtensions.swift
//  DN2
//
//  Created by miha perne on 26/10/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//3DTouch 
extension TaskTableViewController: UIViewControllerPreviewingDelegate{
    //peek
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = taskTableView.indexPathForRowAtPoint(location),
            cell = taskTableView.cellForRowAtIndexPath(indexPath) else {return nil}

        guard let previewVC = storyboard?.instantiateViewControllerWithIdentifier("taskDetail") as? TaskDetailViewController else {return nil}
        
        if let managedTask = fetchedTaskResultsController.objectAtIndexPath(indexPath) as? NSManagedObject,
            selectedTask = managedTask.valueForKey("task") as? Task{
            
            if let image = managedTask.valueForKey("smallTaskImage") as? NSData{
                let taskImage = prepareImageForPresentation(image)
                previewVC.taskImage = taskImage
                cachedImage = taskImage
            }
            else{
                cachedImage = nil
                }
                previewVC.receivedTask = selectedTask
                cachedTask = selectedTask
        }else{
            cachedTask = nil
        }
        previewVC.preferredContentSize = CGSize(width: 0, height: 0)
        previewingContext.sourceRect = cell.frame
        return previewVC
    }
    
    // POP
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        if let stuffVC = storyboard?.instantiateViewControllerWithIdentifier("taskDetail") as? TaskDetailViewController{
            stuffVC.receivedTask = cachedTask
            stuffVC.taskImage = cachedImage
            showViewController(stuffVC, sender: self)
        }
    }
}

/*
extension TaskManager {
    func returnTasksWithStatus(currentStatus: Status) -> [Task]{
        var foundTasks = [Task]()
        for task in tasks{
            if task.status == currentStatus{
                foundTasks.append(task)
            }
        }
    return foundTasks
    }
}*/
