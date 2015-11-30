//
//  Photo.swift
//  Photo Stream
//
//  Created by miha perne on 21/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation
import SwiftyJSON

class Photo: NSObject {
    
    var name: String?
    var highest_rating: Double?
    var imageurl: String?
    
    init(data: JSON) {
        self.name = data["name"].stringValue
        self.highest_rating = data["highest_rating"].doubleValue
        self.imageurl = data["images"][0]["https_url"].stringValue
        print("IMAGEURL\(imageurl)")
    }
}