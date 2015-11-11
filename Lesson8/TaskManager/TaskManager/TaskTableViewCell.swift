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
    @IBOutlet weak var taskDetailsLabel: UILabel!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(taskName: String, taskDetails: String, taskPriority: Priority, taskImage: UIImage?){
        self.taskNameLabel.text = taskName
        self.taskDetailsLabel.text = taskDetails
        self.taskPriorityLabel.text = taskPriority.rawValue
        self.taskImageView.image = taskImage
    }

}
