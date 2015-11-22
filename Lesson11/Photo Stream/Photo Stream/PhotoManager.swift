//
//  PhotoManager.swift
//  Photo Stream
//
//  Created by miha perne on 21/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PhotoManager: NSObject {
    let consumer_key = "7jYsUah2usgvVue2hJfBwZd49bXSqs19B441PkLD"
    let baseurl = "https://api.500px.com/v1/photos/search"

    func getPhotos(var params: [String: String], completion: (photos : [Photo], error : NSError?) -> Void){
        
        params["consumer_key"] = consumer_key
        
        Alamofire.request(.GET, baseurl, parameters: params, encoding: ParameterEncoding.URL, headers: nil).responseJSON { response in

            let jsonData = JSON(data: response.data!)
            var photos : [Photo] = []
            for (_,photo) in jsonData["photos"] {
                let newphoto: Photo = Photo(data: photo)
                photos.append(newphoto)
            }
            return completion(photos: photos, error: nil)
        }

    }

}