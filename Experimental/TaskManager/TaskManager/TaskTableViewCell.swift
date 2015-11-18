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
    
    func setCell(task: Task, image: UIImage?){ //taskName: String, taskDetails: String, status: Status, taskPriority: Priority?, taskImage: UIImage?
        
        //var prioritae: String?
        var statoos: String?
        
        let prioritae: String = {
            switch task.priority?.rawValue{
            case 0?: return "Normal"
            case 1?: return "High"
            case 2?: return "Mega"
            default: return "Normal"
            }
        }()
        
        if let status =  task.status{
            statoos = status.rawValue
        }
        
        self.taskNameLabel.text = "\(task.taskName)\n\(task.details)\nPriority: \(prioritae)\nStatus: \(statoos!)"
        self.taskImageView.image = image
    }
}
