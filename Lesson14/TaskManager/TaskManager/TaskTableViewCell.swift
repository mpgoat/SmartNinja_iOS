//
//  taskTableViewCell.swift
//  TaskManager
//
//  Created by miha perne on 11/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(task: Task, image: UIImage?){
        var status: String?
        let priority: String = {
            switch Int(task.priority!){
            case 0: return "Normal"
            case 1: return "High"
            case 2: return "Mega"
            default: return "Normal"
            }
        }()
        
        if let tempStatus =  task.status{
            status = tempStatus
        }
        
        self.taskNameLabel.text = "\(task.name)\n\(task.details)\nPriority: \(priority)\nStatus: \(status!)"
        self.taskImageView.image = image
    }
}
