//
//  imageViewController.swift
//  DN2
//
//  Created by miha perne on 01/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

class imageViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addTapped")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addTapped")
    }
}
