//
//  ViewController.swift
//  DN61
//
//  Created by miha perne on 05/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit


class SendMessageViewController: UIViewController {
    
    @IBOutlet weak var sendTextField: UITextView!
    
    @IBAction func sendMessageAction(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("TextMessage", object: sendTextField.text)
        
        if let vc = tabBarController as? TabController{
            vc.message = sendTextField.text
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setObject(sendTextField.text, forKey: "loadedMessages")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for viewController in (self.tabBarController?.viewControllers)! {
            viewController.loadViewIfNeeded()
        }
        
        let tapOutsideOfKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tapOutsideOfKeyboard)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let loadedMessaages = defaults.objectForKey("loadedMessages") as? String{
            sendTextField.text = loadedMessaages
            
            //if let vc = tabBarController as? TabController{
             //   vc.message = loadedMessaages
            //}
        }
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
}


