//
//  ReceiveMessageViewController.swift
//  DN61
//
//  Created by miha perne on 05/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

class ReceiveMessageViewController: UIViewController{
    
    @IBOutlet weak var receiveTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // selector mora imeti na koncu : !
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textMessage:", name: "TextMessage", object: nil)
        
    }
    
    func textMessage(notification: NSNotification){
        if let text = notification.object as? String {
            receiveTextView.text = text
        }
    }
}