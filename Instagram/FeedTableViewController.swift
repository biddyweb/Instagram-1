//
//  FeedTableViewController.swift
//  Instagram
//
//  Created by Rustan Corpuz on 12/7/14.
//  Copyright (c) 2014 Rustan Corpuz Software Lab. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    var titles = [String]()
    var usernames = [String]()
    var images = [UIImage]()
    var imageFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFQuery(className:"Post")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                for object in objects {
                    self.titles.append(object["title"] as String)
                    self.usernames.append(object["username"] as String)
                    
                    if let image = object["imagefile"] as? PFFile {
                        self.imageFiles.append(image)
                    }
                    
                     self.tableView.reloadData()
                }
            } else {
                println(error)
            }
            
           
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return titles.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var feedCell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath) as FeedTableViewCell
        
        // Configure the cell...
        
        feedCell.title.text = titles[indexPath.row]
        feedCell.username.text = usernames[indexPath.row]
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (imageData: NSData!, error: NSError!) -> Void in
            if error == nil{
                let image = UIImage(data: imageData)
                feedCell.postedImage.image = image
            }
        }
        
        
        return feedCell
    }
    
    
    
    
}
