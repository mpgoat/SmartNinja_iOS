//
//  WeatherLocationTableViewController.swift
//  Weather
//
//  Created by miha perne on 29/11/15.
//  Copyright © 2015 miha perne. All rights reserved.
//

import UIKit

class WeatherLocationTableViewController: UITableViewController, WeatherDataDelegate {
    
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.qualityOfService = .Background
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 4
        return queue
    }()
    
    let interval = 60.0
    var timerOn = false
    var timer : NSTimer?
    
    let manager = LocationWeatherManager.shared
    var locationWeather = [LocationWeather]()
    
    @IBAction func refreshAction(sender: UIBarButtonItem) {
        
        if timerOn == false{
            sender.tintColor = UIColor.darkGrayColor()
            timerOn = true
            timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "updateCellTemp", userInfo: nil, repeats: true)
        }else{
            sender.tintColor = UIColor.blueColor()
            timerOn = false
            timer?.invalidate()
            timer = nil
        }
    }
    
    func updateCellTemp(){
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadLocationWeather()
        tableView.reloadData()
    }
    
    func weatherDataDidFinish(addLocationViewController : AddLocationViewController) {
        let newLocation = LocationWeather(location: addLocationViewController.location)
        locationWeather.append(newLocation)
        
        addLocationViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appInterupted", name:UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appBecameActive", name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        
        tableView.tableFooterView = UIView()
    }
    
    func refresh () {
        self.tableView.reloadData()
        self.refreshControl!.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            let currentLocationWeather = locationWeather[indexPath.row]
            let lw = manager.locationWeather
            let index = lw.indexOf({ $0 === currentLocationWeather})
                
            var mutableLw = lw
            mutableLw.removeAtIndex(index!)
                
            manager.locationWeather = mutableLw
            manager.saveDataToStorage()
            loadLocationWeather()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            //tableView.reloadData()
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(locationWeather.count)
        return locationWeather.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.detailTextLabel!.text = "Loading..."
        let data = locationWeather[indexPath.row]
        cell.textLabel?.text = data.location
        let operation = UpdateWeather()
        operation.city = data.location!.stringByReplacingOccurrencesOfString(" ", withString: "")
        operation.completionHandler = { temp, weather, _ in
            dispatch_async(dispatch_get_main_queue()) {
                cell.detailTextLabel!.text = String(format:"%.0f°C", temp)
            }
        }
        downloadQueue.addOperation(operation)
        return cell
    }
    
    private func loadLocationWeather() {
        locationWeather.removeAll()
        manager.loadDataFromStorage()
        locationWeather = manager.allLocationWeathers
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showWeather"{
            let destinationVC = segue.destinationViewController as! PresentWeatherViewController
            let city = sender!.textLabel!!.text!
            destinationVC.city = city
            destinationVC.manager.getPhotos(["tag":"\(city)","image_size":"6","rpp":"1"], completion: { (photos, error) -> Void in
                if (error == nil) && !photos.isEmpty{
                    destinationVC.backgroundImage.af_setImageWithURL(NSURL(string: photos[0].imageurl!)!)
                }
            })
        }
    }
    
    func appInterupted(){
        print("app interrupted")
        if timerOn == true{
            print("timer paused")
            timer!.invalidate()
        }
    }
    
    func appBecameActive(){
        print("app active")
        if timerOn == true{
            print("timer resumed")
            NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "updateWeather", userInfo: nil, repeats: true)
        }else{
            updateCellTemp()
        }
    }
    
    deinit{
        if timerOn == true{
            timer!.invalidate()
        }
        self.timer = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
