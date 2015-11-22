//
//  PhotoListTableViewController.swift
//  
//
//  Created by miha perne on 21/11/15.
//
//

extension Array {
    func random() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

import UIKit

class PhotoListTableViewController: UITableViewController {
    
    let carBrands: [String] = ["porsche", "ferrari", "mclaren", "pagani", "koenigsegg", "tesla", "lamborghini", "audi", "bugatii"]
    let manager : PhotoManager = PhotoManager()
    var photos: [Photo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        
        //tableView.estimatedRowHeight = 500.0
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        manager.getPhotos(["tag":"porsche","image_size":"4","rpp":"200"], completion: { (photos, error) -> Void in
            self.photos = photos
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        photos = []
        tableView.reloadData()
    }
    
    func refresh () {
        photos = []
        let randomItem = carBrands.random()
        manager.getPhotos(["tag":"\(randomItem)","image_size":"4","rpp":"200"], completion: { (photos, error) -> Void in
            self.photos = photos
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        })
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tablePhotos = self.photos{
            return tablePhotos.count;
        }
        return 0;
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForSelectedRow
        let vc = segue.destinationViewController as! ImageDetailViewController
        if let cell = tableView.cellForRowAtIndexPath(indexPath!) as? PhotoTableViewCell{
            let image = cell.imgView.image
            print(image)
            vc.img = image
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoTableViewCell
        cell.imgView.image = nil;
        let photo = self.photos[indexPath.row]
        cell.nameLabel.text = photo.name
        cell.imgView.af_setImageWithURL(NSURL(string: photo.imageurl!)!)
        
        return cell
    }
    
}