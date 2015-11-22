//
//  ImageDetailViewController.swift
//  Photo Stream
//
//  Created by miha perne on 22/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit
import AlamofireImage

class ImageDetailViewController: UIViewController, UIScrollViewDelegate{
    
    //@IBOutlet weak var imageDetailView: UIImageView!
    @IBOutlet weak var imageScrollView: UIScrollView!

    var img: UIImage?
    var imageDetailView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageDetailView = UIImageView(image: img!)
        
        //scrollview
        imageScrollView.addSubview(imageDetailView)
        imageScrollView.contentSize = self.view.frame.size
        imageScrollView.bounces = true
        imageScrollView.bouncesZoom = true
        imageScrollView.minimumZoomScale = 0.2
        imageScrollView.maximumZoomScale = 3.0
        imageScrollView.zoomScale = 0.01
        imageScrollView.showsHorizontalScrollIndicator=true
        imageScrollView.showsVerticalScrollIndicator=true
        imageScrollView.delegate=self
        
        //rotation
        let rotationRecogniser = UIRotationGestureRecognizer(target: self, action: "viewRotated:")
        
        //doubletap
        let tapRecogniser = UITapGestureRecognizer(target: self, action: "viewToInitial")
        tapRecogniser.numberOfTapsRequired = 2
        
        //add all the things
        self.view.addGestureRecognizer(tapRecogniser)
        imageScrollView.addGestureRecognizer(rotationRecogniser)
        self.view.addSubview(imageScrollView);
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageDetailView
    }
    
    func viewToInitial(){
        UIView.animateWithDuration(0.3, delay: 0, options: [], animations: {
            self.imageScrollView.transform = CGAffineTransformMakeRotation(0.0)
            }, completion: { _ in })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
    
    func viewRotated(recogniser: UIRotationGestureRecognizer) {
        imageScrollView.transform = CGAffineTransformMakeRotation(recogniser.rotation)
    }
}