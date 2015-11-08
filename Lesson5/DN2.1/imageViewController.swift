//
//  imageViewController.swift
//  DN2
//
//  Created by miha perne on 01/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

protocol SelectedImageDelegate {
    func selectedImage(image : UIImage)
}

class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var delegate : SelectedImageDelegate?
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var imageSize: UILabel!
    @IBAction func selectImage(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageView.contentMode = .ScaleAspectFit
            selectedImageView.image = pickedImage
            imageSize.text = String(selectedImageView.image!.size.width) + " by " + String(selectedImageView.image!.size.height)
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "doneAction")
    }
    
    func doneAction(){
        if let delegateNeki = delegate {
            if let image = selectedImageView.image {
                delegateNeki.selectedImage(image)
            }
        }
        navigationController?.popViewControllerAnimated(true)
    }
}
