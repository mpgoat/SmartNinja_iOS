//
//  PhotoTableViewCell.swift
//  Photo Stream
//
//  Created by miha perne on 21/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        //NSNotificationCenter.defaultCenter().
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
