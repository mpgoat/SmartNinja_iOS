//
//  ViewController.swift
//  Threading Demo
//
//  Created by miha perne on 26/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.progress = 0.6
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(10) * Int64(NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.progress.progress = 0.9
            
        })
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),{
            self.progress.progress = 0.5
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    //nsoperation je wrapper za GCD
    //damo gor nsoperationobject
    //lahko nastavimo kot dependency

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateProgress(){
        //update ui in main thread
    }

}

