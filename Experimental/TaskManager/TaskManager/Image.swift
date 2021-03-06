//
//  Image.swift
//  TaskManager
//
//  Created by miha perne on 03/12/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation
import UIKit

class Image {
    
    //private var image: UIImage?
    //private var imagePath: String?
    
    static let sharedInstance = Image()
    
    func getImagePath(img: UIImage) -> String{
        let imagePath = self.generateImageName()
        
        print ("SAVING FILE: " + imagePath)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let imageData = NSData(data: UIImagePNGRepresentation(img)!)
            imageData.writeToFile(self.pathForFileName(imagePath), atomically: true)
        }
        return imagePath
    }
    
    private func generateImageName () -> String {
        
        let randomImage = String(randomNumber(UINT32_MAX))
        
        return randomImage + ".png"
    }
    
    private func randomNumber (max: UInt32) -> Int {
        return Int(arc4random_uniform(max) + 1)
    }
    
    private func pathForFileName (name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docs: String = paths[0]
        
        return NSString(string: docs).stringByAppendingPathComponent(name)
    }
}