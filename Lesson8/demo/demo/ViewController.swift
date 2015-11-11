//
//  ViewController.swift
//  demo
//
//  Created by miha perne on 09/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func `switch`(sender: UISwitch) {
        if sender.on{
            activity.startAnimating()
            UIView.animateWithDuration(2.0, animations:{
                self.activity.transform = CGAffineTransformMakeScale(4.0, 4.0)
                self.activity.center = CGPointMake(200.0, 200.0)
            })
        
        }
        else{
            activity.stopAnimating()
        }
    }
    
    @IBAction func slider(sender: UISlider) {
        activity.alpha = CGFloat( sender.value)
        
        //activity.frame.size.origin.y
        //activity.bounds
        //activity.center
    }
    @IBOutlet weak var activity: UIActivityIndicatorView!
}

